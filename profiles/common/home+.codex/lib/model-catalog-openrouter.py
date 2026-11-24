#!/usr/bin/env python3

# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

"""Regenerate the Codex model catalog for the OpenRouter provider.

Machine facts (model existence, context window, input modalities) come from
GET https://openrouter.ai/api/v1/models, which is public. Human metadata
(display names, descriptions, reasoning levels, priority) is curated in
CURATED below.

The catalog is written to `model-catalogs/openrouter.json` beside this
script's directory, which the common profile links into
`~/.codex/model-catalogs/`. Entries set `apply_patch_tool_type` to
`freeform`: OpenRouter forwards custom tools to the model unchanged, so
Codex can edit files through its native apply_patch tool. The system prompt
is a separate artifact selected by `model_instructions_file`; see
`BASE_INSTRUCTIONS.openrouter.md`.
"""

from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import NoReturn

MODELS_URL = "https://openrouter.ai/api/v1/models"
# This profile is self-contained: the script sets its output from its own
# location, and resolving the `~/.codex/lib` link lands on the same tree.
CATALOG = (
    Path(__file__).resolve().parents[1] / "model-catalogs" / "openrouter.json"
)
TRUNCATION_LIMIT = 10_000
APPLY_PATCH_TOOL_TYPE = "freeform"


@dataclass(frozen=True)
class Curated:
    """Human metadata for one catalog model, from the OpenRouter model page."""

    id: str
    display_name: str
    description: str
    priority: int
    efforts: list[str]
    default_effort: str | None


# Curated entries, in descending picker priority. `id` is the exact OpenRouter
# model id; codex sends it verbatim as the API `model` field.
CURATED = [
    Curated(
        id="mistralai/mistral-large-4-0",
        display_name="Mistral Large 4",
        description="State-of-the-art open-weight general-purpose multimodal model by Mistral",
        priority=200,
        efforts=["low", "medium", "high"],
        default_effort="high",
    ),
    Curated(
        id="deepseek/deepseek-v4.1-flash-1017",
        display_name="DeepSeek V4.1 Flash 1017",
        description="Fast DeepSeek model for efficient chat, coding help, and agent loops",
        priority=100,
        efforts=["low", "high", "max"],
        default_effort="high",
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


def get_json(url: str) -> object:
    # Audited open call: the url is this module's https constant.
    request = urllib.request.Request(url)  # ruff: ignore[suspicious-url-open-usage]
    try:
        with urllib.request.urlopen(request, timeout=30) as response:  # ruff: ignore[suspicious-url-open-usage]
            return json.load(response)
    except urllib.error.HTTPError as err:
        fail(f"GET {url} failed with HTTP {err.code}")


def load_cards(payload: object) -> dict[str, dict]:
    cards = payload.get("data", []) if isinstance(payload, dict) else payload
    if not isinstance(cards, list):
        fail(f"unexpected /v1/models payload shape: {type(cards).__name__}")
    return {
        card["id"]: card
        for card in cards
        if isinstance(card, dict) and card.get("id")
    }


def build_entry(curated: Curated, card: dict) -> dict:
    architecture = card.get("architecture", {})
    modalities = [
        modality
        for modality in architecture.get("input_modalities", [])
        if modality in {"text", "image"}
    ]
    if "text" not in modalities:
        modalities.insert(0, "text")
    context_window = card.get("context_length")
    if not isinstance(context_window, int):
        fail(f"{curated.id}: missing context_length in the OpenRouter card")
    entry = {
        "slug": curated.id,
        "display_name": curated.display_name,
        "description": curated.description,
        "supported_reasoning_levels": [
            {"effort": effort, "description": EFFORT_DESCRIPTIONS[effort]}
            for effort in curated.efforts
        ],
        "shell_type": "shell_command",
        "visibility": "list",
        "supported_in_api": True,
        "priority": curated.priority,
        "support_verbosity": False,
        "input_modalities": modalities,
        "context_window": context_window,
        "truncation_policy": {"mode": "tokens", "limit": TRUNCATION_LIMIT},
        "experimental_supported_tools": [],
        "apply_patch_tool_type": APPLY_PATCH_TOOL_TYPE,
        # The catalog parser requires a prompt field. Keep it empty; the real
        # prompt comes from model_instructions_file.
        "base_instructions": "",
    }
    if curated.default_effort:
        entry["default_reasoning_level"] = curated.default_effort
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


def check() -> None:
    """Exit non-zero when the catalog breaks an invariant codex relies on."""
    if not CATALOG.is_file():
        fail(f"{CATALOG} does not exist; run `just models-update-openrouter`")
    models = json.loads(CATALOG.read_text(encoding="utf-8")).get("models", [])
    if not models:
        fail(f"{CATALOG} lists no models; run `just models-update-openrouter`")
    for model in models:
        if model.get("apply_patch_tool_type") != APPLY_PATCH_TOOL_TYPE:
            fail(
                f"{model.get('slug')}: apply_patch_tool_type must be "
                f"{APPLY_PATCH_TOOL_TYPE!r}"
            )
        if model.get("base_instructions"):
            fail(
                f"{model.get('slug')}: base_instructions must stay empty; "
                "run `just models-update-openrouter`"
            )
    print(
        f"{len(models)} models, apply_patch_tool_type={APPLY_PATCH_TOOL_TYPE}, "
        "base_instructions empty in each"
    )


def update() -> None:
    cards = load_cards(get_json(MODELS_URL))
    models = []
    for curated in CURATED:
        card = cards.get(curated.id)
        if card is None:
            print(f"- {curated.id}: dropped (absent from the API)")
            continue
        if "tools" not in card.get("supported_parameters", []):
            print(f"- {curated.id}: dropped (does not support tools)")
            continue
        models.append(build_entry(curated, card))
    if not models:
        fail(
            "no curated model is available; refusing to write an empty catalog"
        )

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
        "restart codex to apply (the catalog loads at startup only): "
        "pkill -f 'codex app-server'"
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        action="store_true",
        help="verify the catalog invariants without contacting the API",
    )
    args = parser.parse_args()
    if args.check:
        check()
        return
    update()


if __name__ == "__main__":
    main()
