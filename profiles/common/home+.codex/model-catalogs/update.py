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

import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request
from pathlib import Path

MODELS_URL = "https://api.mistral.ai/v1/models"
PROMPT_URL = (
    "https://raw.githubusercontent.com/openai/codex/"
    "rust-v{version}/codex-rs/models-manager/prompt.md"
)
# The catalog sits next to this script, both linked into ~/.codex/; resolve
# the symlink when invoked from there.
CATALOG = Path(__file__).resolve().parent / "mistral.json"
TRUNCATION_LIMIT = 10_000

# Curated entries, in descending picker priority. `id` is the exact model id on
# La Plateforme; codex sends it verbatim as the API `model` field.
CURATED = [
    {
        "id": "mistral-large-4",
        "display_name": "Mistral Large 4",
        "description": "State-of-the-art open-weight general-purpose multimodal model by Mistral",
        "priority": 400,
        "efforts": ["low", "medium", "high"],
        "default_effort": "high",
    },
    {
        "id": "zai-glm-5-3",
        "display_name": "Z.ai GLM 5.3",
        "description": "Third-party open-weight text model from Z.ai, hosted by Mistral for long-context coding and agentic workflows",
        "priority": 300,
        "efforts": ["low", "high", "max"],
        "default_effort": "high",
    },
    {
        "id": "zai-glm-5-3-flash",
        "display_name": "Z.ai GLM 5.3 Flash",
        "description": "Multimodal third-party model from Z.ai, hosted by Mistral for developer agent workflows and complex tool-use tasks",
        "priority": 200,
        "efforts": ["low", "high", "max"],
        "default_effort": "high",
    },
    {
        "id": "deepseek-v4-1-flash-1017",
        "display_name": "DeepSeek V4.1 Flash 1017",
        "description": "Third-party open-weight model from DeepSeek, hosted by Mistral with support for text and image inputs",
        "priority": 100,
        "efforts": [],
        "default_effort": None,
    },
]

EFFORT_DESCRIPTIONS = {
    "low": "Minimize reasoning compute for simpler tasks",
    "medium": "Balance reasoning quality with token usage and latency",
    "high": "Greater reasoning depth for complex problems",
    "max": "Maximum reasoning depth",
}


def fail(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)


def get_json(url: str, key: str | None = None) -> object:
    request = urllib.request.Request(url)
    if key:
        request.add_header("Authorization", f"Bearer {key}")
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
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
    request = urllib.request.Request(url)
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            return response.read().decode()
    except urllib.error.HTTPError as err:
        fail(
            f"fetching {url} failed with HTTP {err.code}; the release tag may not exist yet"
        )


def fetch_model_cards(key: str) -> dict[str, dict]:
    """Return the API's base-model cards keyed by id, with aliases resolved.

    Fine-tuned models (ids starting with `ft:`) are left out; they are user
    jobs, not provider models worth listing in the catalog.
    """
    payload = get_json(MODELS_URL, key)
    cards = payload.get("data", []) if isinstance(payload, dict) else payload
    by_id: dict[str, dict] = {}
    for card in cards:
        model_id = card.get("id", "")
        if model_id.startswith("ft:") or card.get("archived"):
            continue
        by_id[model_id] = card
        for alias in card.get("aliases", []):
            by_id.setdefault(alias, card)
    return by_id


def build_entry(curated: dict, card: dict, prompt: str) -> dict:
    capabilities = card.get("capabilities", {})
    entry = {
        "slug": curated["id"],
        "display_name": curated["display_name"],
        "description": curated["description"],
        "supported_reasoning_levels": [
            {"effort": effort, "description": EFFORT_DESCRIPTIONS[effort]}
            for effort in curated["efforts"]
        ],
    }
    if curated["default_effort"]:
        entry["default_reasoning_level"] = curated["default_effort"]
    entry.update(
        {
            "shell_type": "shell_command",
            "visibility": "list",
            "supported_in_api": True,
            "priority": curated["priority"],
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
    old_models = {model["slug"]: model for model in old.get("models", [])}
    new_models = {model["slug"]: model for model in new["models"]}
    lines = []
    for slug in sorted(old_models.keys() - new_models.keys()):
        lines.append(f"- {slug}: removed")
    for slug in sorted(new_models.keys() - old_models.keys()):
        lines.append(f"- {slug}: added")
    for slug in sorted(old_models.keys() & new_models.keys()):
        fields = [
            key
            for key in new_models[slug]
            if old_models[slug].get(key) != new_models[slug][key]
        ]
        if fields:
            lines.append(f"- {slug}: updated {', '.join(fields)}")
    return lines


def print_candidates(cards: dict[str, dict], known: set[str]) -> None:
    candidates = sorted(
        {
            card.get("id", model_id)
            for model_id, card in cards.items()
            if card.get("id", model_id) not in known
            and not model_id.startswith("ft:")
            and card.get("capabilities", {}).get("completion_chat")
            and card.get("capabilities", {}).get("function_calling")
        }
    )
    if candidates:
        print(
            "other tool-calling chat models on the API (candidates for CURATED):"
        )
        print("  " + ", ".join(candidates))


def main() -> None:
    key = os.environ.get("MISTRAL_API_KEY")
    if not key:
        fail("MISTRAL_API_KEY is not set (create one at console.mistral.ai)")
    cards = fetch_model_cards(key)
    prompt = fetch_prompt(codex_version())

    models = []
    for curated in CURATED:
        card = cards.get(curated["id"])
        if card is None:
            print(
                f"- {curated['id']}: dropped (absent or archived on the API)"
            )
            continue
        capabilities = card.get("capabilities", {})
        if (
            capabilities.get("completion_chat") is False
            or capabilities.get("function_calling") is False
        ):
            print(
                f"- {curated['id']}: dropped (cannot drive a coding agent: {capabilities})"
            )
            continue
        models.append(build_entry(curated, card, prompt))
    if not models:
        fail(
            "no curated model is available; refusing to write an empty catalog"
        )
    print_candidates(cards, {curated["id"] for curated in CURATED})

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
