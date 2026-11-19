#!/usr/bin/env python3
"""Regenerate the Codex model catalog for the Mistral provider.

Machine facts (model existence, context window, vision support) come from
GET https://api.mistral.ai/v1/models using $MISTRAL_API_KEY. Human metadata
(display names, descriptions, reasoning levels, priority) is curated in
CURATED below, mirroring the model pages on docs.mistral.ai.

base_instructions comes from openai/codex at the tag matching the installed
binary: the prompt is embedded in the binary and changes between releases, so
the `main` branch would drift from what the installed codex expects. Without
any instructions a catalog model runs with an empty system prompt, so the
field must stay.

`apply_patch_tool_type` stays unset on purpose: Mistral's Responses endpoint
accepts only client-executed function tools, and codex serializes the freeform
apply_patch tool as {"type": "custom"}, which the endpoint rejects with error
3051. File edits then go through the shell function tool.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import NoReturn

MODELS_URL = "https://api.mistral.ai/v1/models"
PROMPT_URL = (
    "https://raw.githubusercontent.com/openai/codex/"
    "rust-v{version}/codex-rs/models-manager/prompt.md"
)
# The catalog sits next to this script, both linked into ~/.codex/; resolve
# the symlink when invoked from there.
CATALOG = Path(__file__).resolve().parent / "mistral.json"
TRUNCATION_LIMIT = 10_000


@dataclass(frozen=True)
class Curated:
    """Human metadata for one catalog model, from docs.mistral.ai."""

    id: str
    display_name: str
    description: str
    priority: int
    efforts: list[str]
    default_effort: str | None


# Curated entries, in descending picker priority. `id` is the exact model id on
# La Plateforme; codex sends it verbatim as the API `model` field.
CURATED = [
    Curated(
        id="mistral-large-4",
        display_name="Mistral Large 4",
        description="State-of-the-art open-weight general-purpose multimodal model by Mistral",
        priority=400,
        efforts=["low", "medium", "high"],
        default_effort="high",
    ),
    Curated(
        id="zai-glm-5-3",
        display_name="Z.ai GLM 5.3",
        description="Third-party open-weight text model from Z.ai, hosted by Mistral for long-context coding and agentic workflows",
        priority=300,
        efforts=["low", "high", "max"],
        default_effort="high",
    ),
    Curated(
        id="zai-glm-5-3-flash",
        display_name="Z.ai GLM 5.3 Flash",
        description="Multimodal third-party model from Z.ai, hosted by Mistral for developer agent workflows and complex tool-use tasks",
        priority=200,
        efforts=["low", "high", "max"],
        default_effort="high",
    ),
    Curated(
        id="deepseek-v4-1-flash-1017",
        display_name="DeepSeek V4.1 Flash 1017",
        description="Third-party open-weight model from DeepSeek, hosted by Mistral with support for text and image inputs",
        priority=100,
        efforts=[],
        default_effort=None,
    ),
]

EFFORT_DESCRIPTIONS = {
    "low": "Minimize reasoning compute for simpler tasks",
    "medium": "Balance reasoning quality with token usage and latency",
    "high": "Greater reasoning depth for complex problems",
    "max": "Maximum reasoning depth",
}


def fail(message: str) -> NoReturn:
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)


def get_json(url: str, key: str | None = None) -> object:
    # Only this module's https constants reach these audited open calls.
    request = urllib.request.Request(url)  # ruff: ignore[suspicious-url-open-usage]
    if key:
        request.add_header("Authorization", f"Bearer {key}")
    try:
        with urllib.request.urlopen(request, timeout=30) as response:  # ruff: ignore[suspicious-url-open-usage]
            return json.load(response)
    except urllib.error.HTTPError as err:
        fail(f"GET {url} failed with HTTP {err.code}")


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


def load_cards(payload: object) -> dict[str, dict]:
    """Return base, non-archived cards keyed by their own id.

    Aliases are folded in only by `resolve_card`, with a rule that does not
    depend on the API's array order.
    """
    cards = payload.get("data", []) if isinstance(payload, dict) else payload
    if not isinstance(cards, list):
        fail(f"unexpected /v1/models payload shape: {type(cards).__name__}")
    return {
        card["id"]: card
        for card in cards
        if card.get("id")
        and not card["id"].startswith("ft:")
        and not card.get("archived")
    }


def resolve_card(cards: dict[str, dict], wanted: str) -> dict | None:
    """Resolve a model id to its card, deterministically.

    An exact id always wins. Otherwise the claiming card with the newest
    `created` wins, tie-broken by id: the API lists aliases as mutual cliques
    with identical timestamps, so the tie-break is what usually decides,
    and it never depends on the order of the response array.
    """
    if wanted in cards:
        return cards[wanted]
    claimants = sorted(
        (card for card in cards.values() if wanted in card.get("aliases", [])),
        key=lambda card: (-card.get("created", 0), card["id"]),
    )
    return claimants[0] if claimants else None


def build_entry(curated: Curated, card: dict, prompt: str) -> dict:
    capabilities = card.get("capabilities", {})
    entry = {
        "slug": curated.id,
        "display_name": curated.display_name,
        "description": curated.description,
        "supported_reasoning_levels": [
            {"effort": effort, "description": EFFORT_DESCRIPTIONS[effort]}
            for effort in curated.efforts
        ],
    }
    if curated.default_effort:
        entry["default_reasoning_level"] = curated.default_effort
    entry.update(
        {
            "shell_type": "shell_command",
            "visibility": "list",
            "supported_in_api": True,
            "priority": curated.priority,
            "support_verbosity": False,
            "input_modalities": ["text"]
            + (["image"] if capabilities.get("vision") else []),
            "context_window": card.get("max_context_length"),
            "truncation_policy": {"mode": "tokens", "limit": TRUNCATION_LIMIT},
            "experimental_supported_tools": [],
            "base_instructions": prompt,
        }
    )
    return entry


def summarize(old: dict, new: dict) -> list[str]:
    """One deterministic line per added, removed, or changed model."""
    old_models = {model["slug"]: model for model in old.get("models", [])}
    new_models = {model["slug"]: model for model in new["models"]}
    lines = [
        f"- {slug}: removed"
        for slug in sorted(old_models.keys() - new_models.keys())
    ]
    lines += [
        f"- {slug}: added"
        for slug in sorted(new_models.keys() - old_models.keys())
    ]
    for slug in sorted(old_models.keys() & new_models.keys()):
        fields = sorted(
            key
            for key in set(old_models[slug]) | set(new_models[slug])
            if old_models[slug].get(key) != new_models[slug].get(key)
        )
        if fields:
            lines.append(f"- {slug}: updated {', '.join(fields)}")
    return lines


def alias_groups(cards: dict[str, dict]) -> list[list[str]]:
    """Group card ids into the API's mutual alias cliques.

    The API registers every spelling of one model as its own card and lists
    the siblings as aliases, so "which names are the same model" is exactly
    connected components over the id-to-alias edges, built from sorted names
    so the groups do not depend on the response order.
    """
    parent = {name: name for name in sorted(cards)}

    def root(name: str) -> str:
        while parent[name] != name:
            parent[name] = parent[parent[name]]
            name = parent[name]
        return name

    for name in sorted(cards):
        for alias in sorted(cards[name].get("aliases", [])):
            if alias in parent:
                parent[root(name)] = root(alias)
    groups: dict[str, list[str]] = {}
    for name in sorted(cards):
        groups.setdefault(root(name), []).append(name)
    return list(groups.values())


def print_candidates(cards: dict[str, dict], known: set[str]) -> None:
    """One deterministic line per model family the catalog does not cover."""
    candidates = []
    for group in alias_groups(cards):
        if any(name in known for name in group):
            continue
        card = cards[min(group)]
        capabilities = card.get("capabilities", {})
        if not (
            capabilities.get("completion_chat")
            and capabilities.get("function_calling")
        ):
            continue
        if card.get("deprecation"):
            continue
        candidates.append(min(group))
    if candidates:
        print("model families on the API but not in CURATED:")
        for candidate in sorted(candidates):
            print(f"  {candidate}")


def check_prompt() -> None:
    """Exit non-zero when the catalog prompt is stale for the installed codex.

    The catalog embeds the system prompt from the codex release it was
    generated for. A codex upgrade can change that prompt even when the model
    list does not, so compare the content instead of a version string.
    """
    if not CATALOG.exists():
        fail(f"{CATALOG} does not exist; run `just models-update`")
    version = codex_version()
    expected = fetch_prompt(version)
    models = json.loads(CATALOG.read_text()).get("models", [])
    stale = [
        model["slug"]
        for model in models
        if model.get("base_instructions") != expected
    ]
    if stale:
        fail(
            f"catalog prompt is stale for codex {version} "
            f"({', '.join(stale)}); run `just models-update`"
        )
    print(f"catalog prompt matches codex {version}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        action="store_true",
        help="only verify that the catalog prompt matches the installed codex",
    )
    args = parser.parse_args()
    if args.check:
        check_prompt()
        return

    key = os.environ.get("MISTRAL_API_KEY")
    if not key:
        fail("MISTRAL_API_KEY is not set (create one at console.mistral.ai)")
    cards = load_cards(get_json(MODELS_URL, key))
    prompt = fetch_prompt(codex_version())

    models = []
    for curated in CURATED:
        card = resolve_card(cards, curated.id)
        if card is None:
            print(f"- {curated.id}: dropped (absent or archived on the API)")
            continue
        capabilities = card.get("capabilities", {})
        if (
            capabilities.get("completion_chat") is False
            or capabilities.get("function_calling") is False
        ):
            print(
                f"- {curated.id}: dropped (cannot drive a coding agent: {capabilities})"
            )
            continue
        models.append(build_entry(curated, card, prompt))
    if not models:
        fail(
            "no curated model is available; refusing to write an empty catalog"
        )
    print_candidates(cards, {curated.id for curated in CURATED})

    new_catalog = {"models": models}
    old_catalog = (
        json.loads(CATALOG.read_text()) if CATALOG.exists() else {"models": []}
    )
    changes = summarize(old_catalog, new_catalog)
    if not changes:
        print(f"{CATALOG} is up to date (no changes)")
        return
    CATALOG.parent.mkdir(parents=True, exist_ok=True)
    CATALOG.write_text(
        json.dumps(new_catalog, indent=2, ensure_ascii=False) + "\n"
    )
    print(f"wrote {CATALOG}")
    print("\n".join(changes))
    print(
        "restart codex to apply (the catalog loads at startup only): pkill -f 'codex app-server'"
    )


if __name__ == "__main__":
    main()
