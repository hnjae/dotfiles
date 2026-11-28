#!/usr/bin/env python3

# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

"""Create and compare stable manifests of docs/spec and docs/architecture."""

from __future__ import annotations

import argparse
import hashlib
import json
import operator
import os
import stat
import sys
from pathlib import Path
from typing import Any, TextIO

SCHEMA_VERSION = 1
STAT_FIELDS = ("st_dev", "st_ino", "st_nlink", "st_size", "st_mtime_ns")

UNSTABLE_TREE = "unstable_tree"
INVALID_ROOT = "invalid_root"
UNREADABLE_ENTRY = "unreadable_entry"
UNSUPPORTED_PLATFORM = "unsupported_platform"
INVALID_MANIFEST = "invalid_manifest"


class ManifestError(Exception):
    """An error with a machine-readable code and a message."""

    def __init__(self, error: str, message: str) -> None:
        """Initialize the error with a code and message."""
        super().__init__(message)
        self.error = error


def same_stat(left: os.stat_result, right: os.stat_result) -> bool:
    """Return whether two stat results describe the same unchanged entry.

    Returns:
        Whether the file type and every tracked stat field match.
    """
    return stat.S_IFMT(left.st_mode) == stat.S_IFMT(right.st_mode) and all(
        getattr(left, field) == getattr(right, field) for field in STAT_FIELDS
    )


def entry_type(mode: int) -> str:
    """Return the manifest type for a file mode.

    Returns:
        `file`, `directory`, `symlink`, or `other`.
    """
    if stat.S_ISREG(mode):
        return "file"
    if stat.S_ISDIR(mode):
        return "directory"
    if stat.S_ISLNK(mode):
        return "symlink"
    return "other"


def entry_record(path: str, metadata: os.stat_result) -> dict[str, Any]:
    """Build the manifest record for one filesystem entry.

    Returns:
        The record with path, type, and stable metadata.
    """
    return {
        "path": path,
        "type": entry_type(metadata.st_mode),
        "device": metadata.st_dev,
        "inode": metadata.st_ino,
        "hard_links": metadata.st_nlink,
        "size": metadata.st_size,
        "mtime_ns": metadata.st_mtime_ns,
    }


def directory_flags() -> int:
    """Return open flags for a directory that must not follow links.

    Returns:
        Read-only, close-on-exec, directory-only, and no-follow flags.
    """
    return (
        os.O_RDONLY
        | getattr(os, "O_CLOEXEC", 0)
        | getattr(os, "O_DIRECTORY", 0)
        | getattr(os, "O_NOFOLLOW", 0)
    )


def file_flags() -> int:
    """Return open flags for a regular file that must not follow links.

    Returns:
        Read-only, close-on-exec, and no-follow flags.
    """
    return (
        os.O_RDONLY
        | getattr(os, "O_CLOEXEC", 0)
        | getattr(os, "O_NOFOLLOW", 0)
    )


def open_directory_at(parent_fd: int, name: str, path: str, error: str) -> int:
    """Open a required directory without following symlinks.

    Returns:
        The directory file descriptor.

    Raises:
        ManifestError: The directory is missing, changed, or unreadable.
    """
    try:
        before = os.stat(name, dir_fd=parent_fd, follow_symlinks=False)
    except OSError as exc:
        raise ManifestError(
            error, f"Cannot inspect required directory: {path}"
        ) from exc
    if not stat.S_ISDIR(before.st_mode):
        raise ManifestError(
            error,
            f"Required directory is absent or is not a real directory: {path}",
        )
    try:
        directory_fd = os.open(name, directory_flags(), dir_fd=parent_fd)
    except OSError as exc:
        raise ManifestError(
            error,
            f"Cannot open required directory without following links: {path}",
        ) from exc
    after = os.fstat(directory_fd)
    if not same_stat(before, after):
        os.close(directory_fd)
        raise ManifestError(
            UNSTABLE_TREE, f"Directory changed while opening: {path}"
        )
    return directory_fd


def hash_file_at(
    parent_fd: int, name: str, expected: os.stat_result, path: str
) -> str | None:
    """Return the file's SHA-256, or None when permissions forbid reading it.

    Returns:
        The hex digest, or None when the file cannot be read.

    Raises:
        ManifestError: The file changed while it was opened or hashed.
    """
    try:
        file_fd = os.open(name, file_flags(), dir_fd=parent_fd)
    except PermissionError:
        return None
    except OSError as exc:
        raise ManifestError(
            UNSTABLE_TREE, f"File changed while opening: {path}"
        ) from exc
    try:
        before = os.fstat(file_fd)
        if not stat.S_ISREG(before.st_mode) or not same_stat(expected, before):
            raise ManifestError(
                UNSTABLE_TREE, f"File changed while opening: {path}"
            )
        digest = hashlib.sha256()
        while chunk := os.read(file_fd, 1024 * 1024):
            digest.update(chunk)
        after = os.fstat(file_fd)
        if not same_stat(before, after):
            raise ManifestError(
                UNSTABLE_TREE, f"File changed while hashing: {path}"
            )
        return digest.hexdigest()
    finally:
        os.close(file_fd)


def scan_directory(
    directory_fd: int, relative_path: str
) -> list[dict[str, Any]]:
    """Hash and record every entry under an open directory.

    Returns:
        The records, depth first.

    Raises:
        ManifestError: An entry or the directory changed while scanning.
    """
    before = os.fstat(directory_fd)
    try:
        names = sorted(os.listdir(directory_fd))
    except OSError as exc:
        raise ManifestError(
            UNREADABLE_ENTRY, f"Cannot list directory: {relative_path}"
        ) from exc
    entries: list[dict[str, Any]] = []
    for name in names:
        path = f"{relative_path}/{name}"
        try:
            metadata = os.stat(
                name, dir_fd=directory_fd, follow_symlinks=False
            )
        except OSError as exc:
            raise ManifestError(
                UNSTABLE_TREE, f"Entry changed while inspecting: {path}"
            ) from exc
        record = entry_record(path, metadata)
        if stat.S_ISREG(metadata.st_mode):
            digest = hash_file_at(directory_fd, name, metadata, path)
            if digest is None:
                record["readable"] = False
            else:
                record["sha256"] = digest
        entries.append(record)
        if stat.S_ISDIR(metadata.st_mode):
            try:
                child_fd = open_directory_at(
                    directory_fd, name, path, UNREADABLE_ENTRY
                )
            except ManifestError as exc:
                if not isinstance(exc.__cause__, PermissionError):
                    raise
                record["readable"] = False
                continue
            try:
                entries.extend(scan_directory(child_fd, path))
            finally:
                os.close(child_fd)
    after = os.fstat(directory_fd)
    if not same_stat(before, after):
        raise ManifestError(
            UNSTABLE_TREE,
            f"Directory changed while scanning: {relative_path}",
        )
    return entries


def build_manifest(project_root: Path) -> dict[str, Any]:
    """Build a manifest of docs/spec and docs/architecture.

    Returns:
        The manifest with root and entry records.

    Raises:
        ManifestError: The root is invalid or the tree changed while scanning.
    """
    if (
        not hasattr(os, "O_DIRECTORY")
        or not hasattr(os, "O_NOFOLLOW")
        or os.open not in os.supports_dir_fd
        or os.stat not in os.supports_dir_fd
        or os.listdir not in os.supports_fd
    ):
        raise ManifestError(
            UNSUPPORTED_PLATFORM,
            "Descriptor-relative no-follow traversal is unavailable",
        )
    try:
        canonical_root = project_root.resolve(strict=True)
    except OSError as exc:
        raise ManifestError(
            INVALID_ROOT, "Project root does not exist"
        ) from exc
    if not canonical_root.is_dir():
        raise ManifestError(INVALID_ROOT, "Project root is not a directory")
    try:
        project_fd = os.open(canonical_root, directory_flags())
    except OSError as exc:
        raise ManifestError(
            INVALID_ROOT, "Cannot open the project root"
        ) from exc
    root_records: list[dict[str, Any]] = []
    entries: list[dict[str, Any]] = []
    try:
        project_metadata = os.fstat(project_fd)
        docs_fd = open_directory_at(project_fd, "docs", "docs", INVALID_ROOT)
        try:
            docs_metadata = os.fstat(docs_fd)
            for name in ("spec", "architecture"):
                relative_path = f"docs/{name}"
                allowed_fd = open_directory_at(
                    docs_fd, name, relative_path, INVALID_ROOT
                )
                try:
                    root_metadata = os.fstat(allowed_fd)
                    root_records.append(
                        entry_record(relative_path, root_metadata)
                    )
                    entries.extend(scan_directory(allowed_fd, relative_path))
                    if not same_stat(root_metadata, os.fstat(allowed_fd)):
                        raise ManifestError(
                            UNSTABLE_TREE,
                            f"Directory changed while scanning: {relative_path}",
                        )
                finally:
                    os.close(allowed_fd)
            if not same_stat(docs_metadata, os.fstat(docs_fd)):
                raise ManifestError(
                    UNSTABLE_TREE, "Directory changed while scanning: docs"
                )
        finally:
            os.close(docs_fd)
        if not same_stat(project_metadata, os.fstat(project_fd)):
            raise ManifestError(
                UNSTABLE_TREE, "Project root changed while scanning"
            )
    finally:
        os.close(project_fd)
    entries.sort(key=operator.itemgetter("path"))
    return {
        "schema_version": SCHEMA_VERSION,
        "roots": root_records,
        "entries": entries,
    }


def load_manifest(path: Path) -> dict[str, Any]:
    """Read and validate an expected manifest.

    Returns:
        The validated manifest.

    Raises:
        ManifestError: The file is unreadable, invalid, or of another schema.
    """
    try:
        manifest = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        raise ManifestError(
            INVALID_MANIFEST, "Expected manifest is not readable JSON"
        ) from exc
    if (
        not isinstance(manifest, dict)
        or manifest.get("schema_version") != SCHEMA_VERSION
    ):
        raise ManifestError(
            INVALID_MANIFEST, "Expected manifest has an unsupported schema"
        )
    if not isinstance(manifest.get("roots"), list) or not isinstance(
        manifest.get("entries"), list
    ):
        raise ManifestError(
            INVALID_MANIFEST,
            "Expected manifest is missing required collections",
        )
    return manifest


def index_manifest(manifest: dict[str, Any]) -> dict[str, dict[str, Any]]:
    """Index manifest roots and entries by path.

    Returns:
        The entries keyed by path.

    Raises:
        ManifestError: An entry is invalid or a path repeats.
    """
    indexed: dict[str, dict[str, Any]] = {}
    for entry in [*manifest["roots"], *manifest["entries"]]:
        if not isinstance(entry, dict) or not isinstance(
            entry.get("path"), str
        ):
            raise ManifestError(
                INVALID_MANIFEST, "Manifest contains an invalid entry"
            )
        if entry["path"] in indexed:
            raise ManifestError(
                INVALID_MANIFEST, "Manifest contains duplicate paths"
            )
        indexed[entry["path"]] = entry
    return indexed


def compare_manifests(
    expected: dict[str, Any], current: dict[str, Any]
) -> dict[str, Any]:
    """Compare two manifests entry by entry.

    Returns:
        The added, removed, and changed paths, and whether they are equal.
    """
    expected_entries = index_manifest(expected)
    current_entries = index_manifest(current)
    added = sorted(current_entries.keys() - expected_entries.keys())
    removed = sorted(expected_entries.keys() - current_entries.keys())
    changed = []
    for path in sorted(expected_entries.keys() & current_entries.keys()):
        fields = sorted(
            field
            for field in expected_entries[path].keys()
            | current_entries[path].keys()
            if field != "path"
            and expected_entries[path].get(field)
            != current_entries[path].get(field)
        )
        if fields:
            changed.append({"path": path, "fields": fields})
    equal = not added and not removed and not changed
    return {
        "equal": equal,
        "added": added,
        "removed": removed,
        "changed": changed,
    }


def parser() -> argparse.ArgumentParser:
    """Build the argument parser.

    Returns:
        The parser with the snapshot and compare commands.
    """
    argument_parser = argparse.ArgumentParser(
        description="Create and compare stable manifests for docs/spec and docs/architecture."
    )
    commands = argument_parser.add_subparsers(dest="command", required=True)
    snapshot = commands.add_parser(
        "snapshot", help="Write a manifest to standard output."
    )
    snapshot.add_argument("project_root", type=Path)
    compare = commands.add_parser(
        "compare", help="Compare the project with an expected manifest."
    )
    compare.add_argument("project_root", type=Path)
    compare.add_argument("expected_manifest", type=Path)
    return argument_parser


def write_json(value: dict[str, Any], stream: TextIO) -> None:
    """Write pretty-printed JSON to a text stream."""
    json.dump(value, stream, ensure_ascii=True, indent=2, sort_keys=True)
    stream.write("\n")


def run(arguments: argparse.Namespace) -> int:
    """Run the requested command.

    Returns:
        The process exit status.
    """
    current = build_manifest(arguments.project_root)
    if arguments.command == "snapshot":
        write_json(current, sys.stdout)
        return 0
    expected = load_manifest(arguments.expected_manifest)
    comparison = compare_manifests(expected, current)
    write_json(comparison, sys.stdout)
    return 0 if comparison["equal"] else 1


def main() -> int:
    """Run the command line and report errors as JSON.

    Returns:
        The process exit status.
    """
    arguments = parser().parse_args()
    try:
        return run(arguments)
    except ManifestError as exc:
        write_json({"error": exc.error, "message": str(exc)}, sys.stderr)
        return 2
    except OSError as exc:
        write_json(
            {"error": "operational_error", "message": str(exc)}, sys.stderr
        )
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
