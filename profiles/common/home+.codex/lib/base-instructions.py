#!/usr/bin/env python3

# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

"""Regenerate BASE_INSTRUCTIONS.md from the installed codex release.

The system prompt comes from openai/codex at the tag matching the installed
binary and is written to `BASE_INSTRUCTIONS.md` beside this script's
directory after applying rewrite_prompt. `config.toml` selects the file with
`model_instructions_file`, so the model catalog (`lib/model-catalog.py`)
carries only model metadata. The file is generated; edit rewrite_prompt, not
BASE_INSTRUCTIONS.md.

The prompt cannot stay verbatim. The catalog leaves `apply_patch`
unregistered because Mistral's Responses endpoint rejects the freeform custom
tool codex serializes it as, so rewrite_prompt replaces the upstream
apply_patch instruction with shell-edit guidance and removes the rest of the
mentions that would send the model into a tool that does not exist. A codex
upgrade can change the prompt even when the model list does not, so
`--check` compares the content instead of a version string.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
import urllib.error
import urllib.request
from pathlib import Path
from typing import NoReturn

PROMPT_URL = (
    "https://raw.githubusercontent.com/openai/codex/"
    "rust-v{version}/codex-rs/models-manager/prompt.md"
)
# This profile is self-contained: the script sets its output from its own
# location, and resolving the `~/.codex/lib` link lands on the same tree.
INSTRUCTIONS = Path(__file__).resolve().parents[1] / "BASE_INSTRUCTIONS.md"


def fail(message: str) -> NoReturn:
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)


def codex_version() -> str:
    try:
        out = subprocess.run(
            ["codex", "--version"], capture_output=True, text=True, check=True
        ).stdout
    except (OSError, subprocess.CalledProcessError):
        fail("codex is not on PATH; cannot pin the prompt version")
    match = re.search(r"\d+\.\d+\.\d+", out)
    if not match:
        fail(
            f"cannot parse a version from `codex --version` output: {out.strip()!r}"
        )
    return match.group(0)


def fetch_prompt(version: str) -> str:
    url = PROMPT_URL.format(version=version)
    # Audited open call: the url is built from this module's https constant.
    request = urllib.request.Request(url)  # ruff: ignore[suspicious-url-open-usage]
    try:
        with urllib.request.urlopen(request, timeout=30) as response:  # ruff: ignore[suspicious-url-open-usage]
            return response.read().decode()
    except urllib.error.HTTPError as err:
        fail(
            f"fetching {url} failed with HTTP {err.code}; the release tag may not exist yet"
        )


APPLY_PATCH_BULLET_RE = re.compile(
    r"^- Use the `apply_patch` tool to edit files .*$", re.MULTILINE
)
SHELL_EDIT_BULLET = (
    "- Prefer `ast-grep-outline` skill over `cat` when you need structure map."
)
GIT_COMMIT_BULLET_RE = re.compile(
    r"^- Do not `git commit` your changes or create new git branches "
    r"unless explicitly requested\.$",
    re.MULTILINE,
)
GIT_COMMIT_BULLET = (
    "- Do not `git commit` your changes or create new git branches "
    "unless explicitly requested.\n"
    "- When you commit, use the `git-commit` skill."
)


def rewrite_prompt(prompt: str) -> str:
    """Replace the upstream freeform apply_patch instruction with shell edits.

    Mistral's Responses endpoint rejects custom tools, so the catalog leaves
    apply_patch unregistered. The upstream prompt still tells the model to use
    it, which sends weaker models into a tool that does not exist.
    """

    prompt, count = APPLY_PATCH_BULLET_RE.subn(
        SHELL_EDIT_BULLET, prompt, count=1
    )
    if count != 1:
        fail(
            "could not find the apply_patch instruction in the upstream prompt"
        )
    prompt = prompt.replace(
        "Do not waste tokens by re-reading files after calling `apply_patch` on them. "
        "The tool call will fail if it didn't work.",
        "Do not waste tokens by re-reading files after a successful shell edit. "
        "Check the command output instead.",
        1,
    )
    prompt = prompt.replace(
        "if you've created or modified files using `apply_patch`",
        "if you've created or modified files with the shell",
        1,
    )
    if "apply_patch" in prompt:
        fail(
            "upstream prompt still mentions apply_patch; update rewrite_prompt"
        )
    prompt, count = GIT_COMMIT_BULLET_RE.subn(
        GIT_COMMIT_BULLET, prompt, count=1
    )
    if count != 1:
        fail(
            "could not find the git commit instruction in the upstream prompt"
        )
    return prompt


def write_if_changed(path: Path, body: str) -> bool:
    """Write text atomically, returning whether the file changed."""
    if path.is_file() and path.read_text(encoding="utf-8") == body:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(body, encoding="utf-8")
    temporary.replace(path)
    return True


def check() -> None:
    """Exit non-zero when BASE_INSTRUCTIONS.md is stale for installed codex."""
    if not INSTRUCTIONS.is_file():
        fail(f"{INSTRUCTIONS} does not exist; run `just instructions-update`")
    version = codex_version()
    expected = rewrite_prompt(fetch_prompt(version))
    actual = INSTRUCTIONS.read_text(encoding="utf-8")
    if actual != expected:
        fail(
            f"{INSTRUCTIONS} is stale for codex {version}; "
            "run `just instructions-update`"
        )
    print(f"instructions match codex {version}")


def update() -> None:
    prompt = rewrite_prompt(fetch_prompt(codex_version()))
    if write_if_changed(INSTRUCTIONS, prompt):
        print(f"wrote {INSTRUCTIONS}")
        print("restart codex to apply: pkill -f 'codex app-server'")
    else:
        print(f"{INSTRUCTIONS} is up to date")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        action="store_true",
        help="only verify that BASE_INSTRUCTIONS.md matches the installed codex",
    )
    args = parser.parse_args()
    if args.check:
        check()
        return
    update()


if __name__ == "__main__":
    main()
