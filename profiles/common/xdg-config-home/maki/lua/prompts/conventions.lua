-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- The stock conventions forbid committing unless asked, which contradicts the
-- project instructions this agent runs under. Replace the section instead of
-- appending to it; `conventions` accepts no hints. A copy of
-- maki-agent/src/prompts/system_conventions.md, current as of maki commit
-- 2b6aaeeb (2026-11-25T23:55:38+09:00); diff it again when maki updates that
-- file.
maki.api.set_prompt({
  prompt = "system",
  slot = "conventions",
  content = [[
- Never assume a library is available. Check the project's dependency files first.
- Match existing code style, naming conventions, and patterns.
- Follow security best practices. Never expose secrets or keys.
- Never push unless explicitly asked.
- Never force push, skip hooks, or amend commits you didn't create.
- Never commit secrets (.env, credentials, keys).
- When referencing code, use `file_path:line_number` format.]],
})
