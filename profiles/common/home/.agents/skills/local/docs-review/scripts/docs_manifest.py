#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import stat
import sys
from typing import Any


SCHEMA_VERSION = 1
STAT_FIELDS = ("st_dev", "st_ino", "st_nlink", "st_size", "st_mtime_ns")


class ManifestError(Exception):
    def __init__(self, error: str, message: str) -> None:
        super().__init__(message)
        self.error = error


def same_stat(left: os.stat_result, right: os.stat_result) -> bool:
    return stat.S_IFMT(left.st_mode) == stat.S_IFMT(right.st_mode) and all(
        getattr(left, field) == getattr(right, field) for field in STAT_FIELDS
    )


def entry_type(mode: int) -> str:
    if stat.S_ISREG(mode):
        return "file"
    if stat.S_ISDIR(mode):
        return "directory"
    if stat.S_ISLNK(mode):
        return "symlink"
    return "other"


def entry_record(path: str, metadata: os.stat_result) -> dict[str, Any]:
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
    return (
        os.O_RDONLY
        | getattr(os, "O_CLOEXEC", 0)
        | getattr(os, "O_DIRECTORY", 0)
        | getattr(os, "O_NOFOLLOW", 0)
    )


def file_flags() -> int:
    return (
        os.O_RDONLY
        | getattr(os, "O_CLOEXEC", 0)
        | getattr(os, "O_NOFOLLOW", 0)
    )


def open_directory_at(parent_fd: int, name: str, path: str, error: str) -> int:
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
            "unstable_tree", f"Directory changed while opening: {path}"
        )
    return directory_fd


def hash_file_at(
    parent_fd: int, name: str, expected: os.stat_result, path: str
) -> str:
    try:
        file_fd = os.open(name, file_flags(), dir_fd=parent_fd)
    except OSError as exc:
        raise ManifestError(
            "unstable_tree", f"File changed while opening: {path}"
        ) from exc
    try:
        before = os.fstat(file_fd)
        if not stat.S_ISREG(before.st_mode) or not same_stat(expected, before):
            raise ManifestError(
                "unstable_tree", f"File changed while opening: {path}"
            )
        digest = hashlib.sha256()
        while chunk := os.read(file_fd, 1024 * 1024):
            digest.update(chunk)
        after = os.fstat(file_fd)
        if not same_stat(before, after):
            raise ManifestError(
                "unstable_tree", f"File changed while hashing: {path}"
            )
        return digest.hexdigest()
    finally:
        os.close(file_fd)


def scan_directory(
    directory_fd: int, relative_path: str
) -> list[dict[str, Any]]:
    before = os.fstat(directory_fd)
    try:
        names = sorted(os.listdir(directory_fd))
    except OSError as exc:
        raise ManifestError(
            "unreadable_entry", f"Cannot list directory: {relative_path}"
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
                "unstable_tree", f"Entry changed while inspecting: {path}"
            ) from exc
        record = entry_record(path, metadata)
        if stat.S_ISREG(metadata.st_mode):
            record["sha256"] = hash_file_at(directory_fd, name, metadata, path)
        entries.append(record)
        if stat.S_ISDIR(metadata.st_mode):
            child_fd = open_directory_at(
                directory_fd, name, path, "unreadable_entry"
            )
            try:
                entries.extend(scan_directory(child_fd, path))
            finally:
                os.close(child_fd)
    after = os.fstat(directory_fd)
    if not same_stat(before, after):
        raise ManifestError(
            "unstable_tree",
            f"Directory changed while scanning: {relative_path}",
        )
    return entries


def hard_link_groups(entries: list[dict[str, Any]]) -> list[dict[str, Any]]:
    grouped: dict[tuple[int, int], list[dict[str, Any]]] = {}
    for entry in entries:
        if entry["type"] == "file" and entry["hard_links"] > 1:
            grouped.setdefault((entry["device"], entry["inode"]), []).append(
                entry
            )
    groups = []
    for aliases in grouped.values():
        paths = sorted(entry["path"] for entry in aliases)
        link_count = aliases[0]["hard_links"]
        groups.append(
            {
                "paths": paths,
                "link_count": link_count,
                "has_unaccounted_aliases": link_count > len(paths),
            }
        )
    return sorted(groups, key=lambda group: group["paths"])


def build_manifest(project_root: Path) -> dict[str, Any]:
    if (
        not hasattr(os, "O_DIRECTORY")
        or not hasattr(os, "O_NOFOLLOW")
        or os.open not in os.supports_dir_fd
        or os.stat not in os.supports_dir_fd
        or os.listdir not in os.supports_fd
    ):
        raise ManifestError(
            "unsupported_platform",
            "Descriptor-relative no-follow traversal is unavailable",
        )
    try:
        canonical_root = project_root.resolve(strict=True)
    except OSError as exc:
        raise ManifestError(
            "invalid_root", "Project root does not exist"
        ) from exc
    if not canonical_root.is_dir():
        raise ManifestError("invalid_root", "Project root is not a directory")
    try:
        project_fd = os.open(canonical_root, directory_flags())
    except OSError as exc:
        raise ManifestError(
            "invalid_root", "Cannot open the project root"
        ) from exc
    root_records: list[dict[str, Any]] = []
    entries: list[dict[str, Any]] = []
    try:
        project_metadata = os.fstat(project_fd)
        docs_fd = open_directory_at(project_fd, "docs", "docs", "invalid_root")
        try:
            docs_metadata = os.fstat(docs_fd)
            for name in ("spec", "architecture"):
                relative_path = f"docs/{name}"
                allowed_fd = open_directory_at(
                    docs_fd, name, relative_path, "invalid_root"
                )
                try:
                    root_metadata = os.fstat(allowed_fd)
                    root_records.append(
                        entry_record(relative_path, root_metadata)
                    )
                    entries.extend(scan_directory(allowed_fd, relative_path))
                    if not same_stat(root_metadata, os.fstat(allowed_fd)):
                        raise ManifestError(
                            "unstable_tree",
                            f"Directory changed while scanning: {relative_path}",
                        )
                finally:
                    os.close(allowed_fd)
            if not same_stat(docs_metadata, os.fstat(docs_fd)):
                raise ManifestError(
                    "unstable_tree", "Directory changed while scanning: docs"
                )
        finally:
            os.close(docs_fd)
        if not same_stat(project_metadata, os.fstat(project_fd)):
            raise ManifestError(
                "unstable_tree", "Project root changed while scanning"
            )
    finally:
        os.close(project_fd)
    entries.sort(key=lambda entry: entry["path"])
    return {
        "schema_version": SCHEMA_VERSION,
        "roots": root_records,
        "entries": entries,
        "hard_link_groups": hard_link_groups(entries),
    }


def load_manifest(path: Path) -> dict[str, Any]:
    try:
        manifest = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        raise ManifestError(
            "invalid_manifest", "Expected manifest is not readable JSON"
        ) from exc
    if (
        not isinstance(manifest, dict)
        or manifest.get("schema_version") != SCHEMA_VERSION
    ):
        raise ManifestError(
            "invalid_manifest", "Expected manifest has an unsupported schema"
        )
    if not isinstance(manifest.get("roots"), list) or not isinstance(
        manifest.get("entries"), list
    ):
        raise ManifestError(
            "invalid_manifest",
            "Expected manifest is missing required collections",
        )
    return manifest


def index_manifest(manifest: dict[str, Any]) -> dict[str, dict[str, Any]]:
    indexed: dict[str, dict[str, Any]] = {}
    for entry in [*manifest["roots"], *manifest["entries"]]:
        if not isinstance(entry, dict) or not isinstance(
            entry.get("path"), str
        ):
            raise ManifestError(
                "invalid_manifest", "Manifest contains an invalid entry"
            )
        if entry["path"] in indexed:
            raise ManifestError(
                "invalid_manifest", "Manifest contains duplicate paths"
            )
        indexed[entry["path"]] = entry
    return indexed


def compare_manifests(
    expected: dict[str, Any], current: dict[str, Any]
) -> dict[str, Any]:
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


def write_json(value: dict[str, Any], stream: Any) -> None:
    json.dump(value, stream, ensure_ascii=True, indent=2, sort_keys=True)
    stream.write("\n")


def main() -> int:
    arguments = parser().parse_args()
    try:
        current = build_manifest(arguments.project_root)
        if arguments.command == "snapshot":
            write_json(current, sys.stdout)
            return 0
        expected = load_manifest(arguments.expected_manifest)
        comparison = compare_manifests(expected, current)
        write_json(comparison, sys.stdout)
        return 0 if comparison["equal"] else 1
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
