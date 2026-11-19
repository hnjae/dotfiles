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

`BASE_INSTRUCTIONS.md` holds the system prompt selected by `model_instructions_file`; `model-catalogs/mistral.json` holds only model metadata. Both are generated from the installed codex release. After upgrading codex, run:

```console
just models-check
just models-update
```

`models-check` downloads only the prompt for the installed release and needs no Mistral key. Do not edit `BASE_INSTRUCTIONS.md` directly; change `rewrite_prompt` in `model-catalogs/update.py` instead. Run `codex doctor` for provider, MCP, and config checks; the `terminal.env` failure on missing `TERMINFO_DIRS` entries is harmless.
