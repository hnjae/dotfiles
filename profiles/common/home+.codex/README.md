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

`model-catalogs/mistral.json` embeds the system prompt from the codex release it was generated for. After upgrading codex, run:

```console
just models-check
just models-update
```

`models-check` downloads only the prompt for the installed release and needs no Mistral key. Run `codex doctor` for provider, MCP, and config checks; the `terminal.env` failure on missing `TERMINFO_DIRS` entries is harmless.
