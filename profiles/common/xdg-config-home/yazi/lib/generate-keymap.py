#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import TypeAlias

import tomllib

SCRIPT_PATH = Path(__file__).resolve()
PROJECT_DIR = SCRIPT_PATH.parent.parent
DEFAULT_KEYMAP_PATH = PROJECT_DIR / "keymap.toml"


KeySignature: TypeAlias = str | tuple[str] | tuple[str, str]


SECTION_HEADERS: dict[KeySignature, str] = {
    "Q": "Quit",
    ("d",): "Files",
    ("r",): "Sorting",
    ("g", "h"): "Navigation",
    ("m", "c"): "Clipboard",
    ("i", "s"): "Linemode",
    ("c", "("): "Copy Helpers",
    ("c", "c"): "Disabled Defaults",
    ("1",): "Relative Motions",
}


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
        return on
    if isinstance(on, list):
        if len(on) == 1 and isinstance(on[0], str):
            return (on[0],)
        if len(on) == 2:
            first = on[0]
            second = on[1]
            if isinstance(first, str) and isinstance(second, str):
                return (first, second)
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


def build_text(entries: list[dict[str, object]]) -> str:
    lines = [
        "# Regroup this file with `python3 lib/generate-keymap.py` after edits.",
        "",
        "[mgr]",
        "prepend_keymap = [",
    ]

    first_entry = True
    for entry in entries:
        signature = key_signature(entry)
        header = (
            SECTION_HEADERS.get(signature) if signature is not None else None
        )
        if header is not None:
            if not first_entry:
                lines.append("")
            lines.append(f"  # {header}")

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
    if roundtrip != {"mgr": {"prepend_keymap": entries}}:
        raise RuntimeError("generated keymap is not a semantic roundtrip")

    path.write_text(text, encoding="utf-8")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, RuntimeError, TypeError, ValueError) as err:
        print(f"error: {err}", file=sys.stderr)
        raise SystemExit(1)
