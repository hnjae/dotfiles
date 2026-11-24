---
date: 2026-11-18T23:51:14+0900
lastmod: 2026-11-18T23:51:14+0900
---

## Bootstrap

```console
codex mcp login exa
codex mcp login context7
```

## Maintenance

Three files here are generated, and each has its own generator in `lib/`, because they age on different clocks: each catalog follows its provider's API, and the prompt follows the installed codex binary. This directory is self-contained, so it holds the generators too and works as a copy without the rest of the repository.

- `model-catalogs/mistral.json` holds only model metadata, selected by `model_catalog_json`. `just models-update-mistral` refreshes it from the Mistral API and formats it with biome; the key is read from 1Password, so `op` must be signed in. `just models-check-mistral` verifies it offline, without the API or the key.
- `model-catalogs/openrouter.json` holds OpenRouter model metadata, selected by `model_catalog_json`. `just models-update-openrouter` refreshes it from the public OpenRouter models API and formats it with biome; no key is needed. `just models-check-openrouter` verifies it offline. Its entries set `apply_patch_tool_type` to `freeform` because OpenRouter forwards Codex's custom tool to the model unchanged.
- `BASE_INSTRUCTIONS.md` holds the system prompt selected by `model_instructions_file`. `just instructions-update` rewrites it from the prompt pinned to the installed codex release; `just instructions-check` compares it without writing, and downloads only that prompt.

`just models-update` refreshes both catalogs, OpenRouter first because it needs no credentials. `just models-check` verifies both offline.

`lib/base-instructions.py` currently generates the Mistral variant, which replaces the apply_patch instruction with shell-edit guidance because Mistral rejects custom tools. Do not run `just instructions-update` while the OpenRouter catalog is active; the checked-in `BASE_INSTRUCTIONS.md` is the upstream prompt with apply_patch.

After upgrading codex while the Mistral profile is active, run `just instructions-check` and then `just instructions-update`. Run the recipes from this directory, where just finds this justfile.

Do not edit any of these files directly: change `CURATED` in `lib/model-catalog.py` for Mistral, `CURATED` in `lib/model-catalog-openrouter.py` for OpenRouter, or `rewrite_prompt` in `lib/base-instructions.py` for the Mistral prompt. Run `codex doctor` for provider, MCP, and config checks; the `terminal.env` failure on missing `TERMINFO_DIRS` entries is harmless.
