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

Four files here are generated, and each has its own generator in `lib/`, because they age on different clocks: each catalog follows its provider's API, and the prompt files follow the installed codex binary. This directory is self-contained, so it holds the generators too and works as a copy without the rest of the repository.

- `model-catalogs/mistral.json` holds only model metadata, selected by `model_catalog_json`. `just models-update-mistral` refreshes it from the Mistral API and formats it with biome; the key is read from 1Password, so `op` must be signed in. `just models-check-mistral` verifies it offline, without the API or the key.
- `model-catalogs/openrouter.json` holds OpenRouter model metadata, selected by `model_catalog_json`. `just models-update-openrouter` refreshes it from the public OpenRouter models API and formats it with biome; no key is needed. `just models-check-openrouter` verifies it offline. Its entries set `apply_patch_tool_type` to `freeform` because OpenRouter forwards Codex's custom tool to the model unchanged.
- `BASE_INSTRUCTIONS.openrouter.md` holds the OpenRouter system prompt selected by `model_instructions_file`. It keeps the upstream apply_patch instruction and adds the `git-commit` skill instruction.
- `BASE_INSTRUCTIONS.mistral.md` holds the Mistral system prompt. It replaces the apply_patch instruction with shell-edit guidance because Mistral rejects custom tools, and adds the same `git-commit` skill instruction.

`just models-update` refreshes both catalogs, OpenRouter first because it needs no credentials. `just models-check` verifies both offline.

`just instructions-update` rewrites both prompt files from the prompt pinned to the installed codex release and formats them with `rumdl fmt`; `rumdl` must be on `PATH`. `just instructions-check` compares both without writing, and downloads only that prompt.

After upgrading codex, run `just instructions-check` and then `just instructions-update`. Run the recipes from this directory, where just finds this justfile.

Do not edit any of these files directly: change `CURATED` in `lib/model-catalog-mistral.py` for Mistral, `CURATED` in `lib/model-catalog-openrouter.py` for OpenRouter, or `rewrite_common` and `rewrite_mistral` in `lib/base-instructions.py` for the prompts. Run `codex doctor` for provider, MCP, and config checks; the `terminal.env` failure on missing `TERMINFO_DIRS` entries is harmless.
