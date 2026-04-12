#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import sys
from collections import Counter
from pathlib import Path
from typing import TypeAlias

import tomllib

SCRIPT_PATH = Path(__file__).resolve()
PROJECT_DIR = SCRIPT_PATH.parent.parent
DEFAULT_KEYMAP_PATH = PROJECT_DIR / "keymap.toml"


KeySignature: TypeAlias = tuple[str, ...]


SECTION_ORDER = (
    "Disabled Defaults",
    "Quit",
    "Files",
    "Sorting",
    "Navigation",
    "Clipboard",
    "System clipboard",
    "Linemode",
    "Copy Helpers",
    "Relative Motions",
    "Extra Cmds",
)


def load_keymap(path: Path) -> list[dict[str, object]]:
    doc = tomllib.loads(path.read_text(encoding="utf-8"))

    if set(doc) != {"mgr"}:
        raise ValueError("expected only the [mgr] table in keymap.toml")

    mgr = doc["mgr"]
    if not isinstance(mgr, dict) or set(mgr) != {"prepend_keymap"}:
        raise ValueError("expected only mgr.prepend_keymap in keymap.toml")

    entries = mgr["prepend_keymap"]
    if not isinstance(entries, list) or not all(
        isinstance(entry, dict) for entry in entries
    ):
        raise ValueError(
            "expected mgr.prepend_keymap to be an array of tables"
        )

    return entries


def key_signature(entry: dict[str, object]) -> KeySignature | None:
    on = entry.get("on")
    if isinstance(on, str):
        return (on,)
    if isinstance(on, list) and on and all(isinstance(key, str) for key in on):
        return tuple(key for key in on if isinstance(key, str))
    return None


def is_noop(entry: dict[str, object]) -> bool:
    run = entry.get("run")
    if run == "noop":
        return True
    return isinstance(run, list) and len(run) == 1 and run[0] == "noop"


def section_name(entry: dict[str, object]) -> str | None:
    signature = key_signature(entry)
    if signature is None:
        if is_noop(entry):
            return "Disabled Defaults"
        return None

    first = signature[0]

    if first == "z" or signature in {("<F4>",)}:
        return "Extra Cmds"

    if is_noop(entry):
        return "Disabled Defaults"

    if signature in {("q", "q"), ("Q",), ("<F12>",)}:
        return "Quit"
    if signature in {
        ("d",),
        ("%",),
        ("D",),
        ("<F8>",),
        ("<F3>",),
        ("a",),
        ("A",),
        ("R",),
    }:
        return "Files"
    if signature in {("r",), ("s",)}:
        return "Sorting"
    if first == "g" or signature in {
        ("u",),
        ("U",),
        ("-",),
        ("q", "f"),
        ("x",),
        ("p",),
        ("P",),
        ("<Enter>",),
    }:
        return "Navigation"
    if first == "m":
        return "Clipboard"
    if first == "y":
        return "System clipboard"
    if first == "i":
        return "Linemode"
    if first == "c":
        return "Copy Helpers"
    if len(first) == 1 and first.isdigit():
        return "Relative Motions"

    return None


def ordered_items(entry: dict[str, object]) -> list[tuple[str, object]]:
    items = []
    seen = set()

    for key in ("on", "run", "desc"):
        if key in entry:
            items.append((key, entry[key]))
            seen.add(key)

    for key, value in entry.items():
        if key not in seen:
            items.append((key, value))

    return items


def render_value(value: object) -> str:
    if isinstance(value, str):
        return json.dumps(value)
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        return repr(value)
    if isinstance(value, list):
        return "[" + ", ".join(render_value(item) for item in value) + "]"

    raise TypeError(f"unsupported TOML value: {value!r}")


def canonical_entry(entry: dict[str, object]) -> str:
    return json.dumps(entry, sort_keys=True, separators=(",", ":"))


def build_text(entries: list[dict[str, object]]) -> str:
    grouped = {section: [] for section in SECTION_ORDER}
    other_entries = []

    for entry in entries:
        section = section_name(entry)
        if section is None:
            other_entries.append(entry)
        else:
            grouped[section].append(entry)

    lines = [
        "# Regroup this file with `python3 lib/generate-keymap.py` after edits.",
        "",
        "[mgr]",
        "prepend_keymap = [",
    ]

    first_entry = True
    for header in SECTION_ORDER:
        section_entries = grouped[header]
        if not section_entries:
            continue

        if not first_entry:
            lines.append("")
        lines.append(f"  # {header}")

        for entry in section_entries:
            rendered = ", ".join(
                f"{key} = {render_value(value)}"
                for key, value in ordered_items(entry)
            )
            lines.append(f"  {{ {rendered} }},")
            first_entry = False

    if other_entries:
        if not first_entry:
            lines.append("")
        lines.append("  # Other")

        for entry in other_entries:
            rendered = ", ".join(
                f"{key} = {render_value(value)}"
                for key, value in ordered_items(entry)
            )
            lines.append(f"  {{ {rendered} }},")
            first_entry = False

    lines.extend(
        [
            "]",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Regroup Yazi keymap.toml")
    parser.add_argument("path", nargs="?", default=str(DEFAULT_KEYMAP_PATH))
    args = parser.parse_args()

    path = Path(args.path)
    entries = load_keymap(path)
    text = build_text(entries)

    roundtrip = tomllib.loads(text)
    roundtrip_entries = roundtrip["mgr"]["prepend_keymap"]
    if Counter(
        canonical_entry(entry) for entry in roundtrip_entries
    ) != Counter(canonical_entry(entry) for entry in entries):
        raise RuntimeError(
            "generated keymap does not preserve the same entries"
        )

    path.write_text(text, encoding="utf-8")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, RuntimeError, TypeError, ValueError) as err:
        print(f"error: {err}", file=sys.stderr)
        raise SystemExit(1)
