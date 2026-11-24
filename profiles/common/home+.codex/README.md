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

Two files here are generated, and each has its own generator in `lib/`, because they age on different clocks: the catalog follows the Mistral API, the prompt follows the installed codex binary. This directory is self-contained, so it holds the generators too and works as a copy without the rest of the repository.

- `model-catalogs/mistral.json` holds only model metadata, selected by `model_catalog_json`. `just models-update` refreshes it from the Mistral API and formats it with biome; the key is read from 1Password, so `op` must be signed in. `just models-check` verifies it offline, without the API or the key.
- `BASE_INSTRUCTIONS.md` holds the system prompt selected by `model_instructions_file`. `just instructions-update` rewrites it from the prompt pinned to the installed codex release; `just instructions-check` compares it without writing, and downloads only that prompt.

After upgrading codex, run `just instructions-check` and then `just instructions-update`. Run the recipes from this directory, where just finds this justfile.

Do not edit either file directly: change `CURATED` in `lib/model-catalog.py`, or `rewrite_prompt` in `lib/base-instructions.py`. Run `codex doctor` for provider, MCP, and config checks; the `terminal.env` failure on missing `TERMINFO_DIRS` entries is harmless.
