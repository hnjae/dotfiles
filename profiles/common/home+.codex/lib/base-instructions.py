#!/usr/bin/env python3

# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

"""Regenerate the provider-specific prompt files from the installed codex release.

The upstream system prompt comes from openai/codex at the tag matching the
installed binary. This script writes two files beside itself:

- `BASE_INSTRUCTIONS.openrouter.md` keeps the upstream `apply_patch`
  instruction, because the OpenRouter catalog registers the freeform tool.
- `BASE_INSTRUCTIONS.mistral.md` replaces `apply_patch` with shell-edit
  guidance, because Mistral's Responses endpoint rejects custom tools.

Both files add the repository's `git-commit` skill instruction through
`rewrite_common`; only the Mistral variant runs `rewrite_mistral`.
The rendered Markdown is then formatted with `rumdl fmt` so the checked-in
files match the repository's Markdown rules.
`config.toml` selects the active file with `model_instructions_file`, so the
model catalogs carry only model metadata. The prompt files are generated;
edit the rewrite functions, not the outputs. A codex upgrade can change the
prompt even when the model list does not, so `--check` compares content
instead of a version string.
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
# This profile is self-contained: the script sets its outputs from its own
# location, and resolving the `~/.codex/lib` link lands on the same tree.
PROMPT_DIR = Path(__file__).resolve().parents[1]
PROMPT_FILES = {
    "openrouter": PROMPT_DIR / "BASE_INSTRUCTIONS.openrouter.md",
    "mistral": PROMPT_DIR / "BASE_INSTRUCTIONS.mistral.md",
}


def fail(message: str) -> NoReturn:
    """Print an error message and exit with status 1."""
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)


def codex_version() -> str:
    """Return the installed codex version.

    Returns:
        The dotted version parsed from `codex --version`.
    """
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
    """Fetch the upstream prompt for a codex release.

    Returns:
        The prompt text.
    """
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


def rewrite_common(prompt: str) -> str:
    """Add the repository's commit guidance to the upstream prompt.

    Returns:
        The rewritten prompt.
    """
    prompt, count = GIT_COMMIT_BULLET_RE.subn(
        GIT_COMMIT_BULLET, prompt, count=1
    )
    if count != 1:
        fail(
            "could not find the git commit instruction in the upstream prompt"
        )
    return prompt


def rewrite_mistral(prompt: str) -> str:
    """Replace the upstream freeform apply_patch instruction with shell edits.

    Mistral's Responses endpoint rejects custom tools, so the Mistral catalog
    leaves apply_patch unregistered. The upstream prompt still tells the model
    to use it, which sends weaker models into a tool that does not exist.

    Returns:
        The rewritten prompt.
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
            "upstream prompt still mentions apply_patch; update rewrite_mistral"
        )
    return prompt


def format_markdown(body: str) -> str:
    """Format generated Markdown with the repository's rumdl configuration.

    Returns:
        The formatted Markdown.
    """
    try:
        result = subprocess.run(
            ["rumdl", "fmt", "-"],
            input=body,
            text=True,
            capture_output=True,
            check=True,
        )
    except FileNotFoundError:
        fail("rumdl is not on PATH; cannot format the prompt files")
    except subprocess.CalledProcessError as err:
        fail(f"rumdl fmt failed: {err.stderr.strip()}")
    return result.stdout


def render(version: str) -> dict[Path, str]:
    """Render both provider prompts from one upstream fetch.

    Returns:
        The rendered body for each provider.
    """
    common = rewrite_common(fetch_prompt(version))
    if "apply_patch" not in common:
        fail(
            "upstream prompt no longer mentions apply_patch; "
            "update rewrite_common"
        )
    return {
        PROMPT_FILES["openrouter"]: format_markdown(common),
        PROMPT_FILES["mistral"]: format_markdown(rewrite_mistral(common)),
    }


def write_if_changed(path: Path, body: str) -> bool:
    """Write text atomically, returning whether the file changed.

    Returns:
        Whether the file content changed.
    """
    if path.is_file() and path.read_text(encoding="utf-8") == body:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(body, encoding="utf-8")
    temporary.replace(path)
    return True


def check() -> None:
    """Exit non-zero when either prompt file is stale for installed codex."""
    version = codex_version()
    expected = render(version)
    for path, body in expected.items():
        if not path.is_file():
            fail(f"{path} does not exist; run `just instructions-update`")
        actual = path.read_text(encoding="utf-8")
        if actual != body:
            fail(
                f"{path} is stale for codex {version}; "
                "run `just instructions-update`"
            )
    print(f"instructions match codex {version} ({len(expected)} files)")


def update() -> None:
    """Write both prompt files when their content changed."""
    version = codex_version()
    changed = False
    for path, body in render(version).items():
        if write_if_changed(path, body):
            print(f"wrote {path}")
            changed = True
        else:
            print(f"{path} is up to date")
    if changed:
        print("restart codex to apply: pkill -f 'codex app-server'")


def main() -> None:
    """Run the command-line interface."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        action="store_true",
        help="only verify that both prompt files match the installed codex",
    )
    args = parser.parse_args()
    if args.check:
        check()
        return
    update()


if __name__ == "__main__":
    main()
