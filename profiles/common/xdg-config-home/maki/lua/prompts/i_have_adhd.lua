-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- Keep the `i-have-adhd` skill active from the first turn of every session.
--
-- Maki loads skills lazily through the `skill` tool, and this skill's
-- description tells the model it is invoked by hand, so it would never be
-- picked up on its own. Injecting the body into the system prompt is the only
-- way to have it apply to every reply without a paid warm-up turn.
--
-- `after_instructions` is the last slot of `system.md`, so the rules land after
-- the project instructions, and `prompt = "system"` keeps them out of the
-- research and general subagent prompts, which write tool results rather than
-- replies. The body is read from the skill pool instead of copied here, so the
-- skill stays the single source; a skill edit takes effect on the next start.
--
-- Prompt hints are ungated, so this needs no permission beyond the `fs_read`
-- that plugin.toml already grants.

local SKILL_PATH = "~/.agents/skills/i-have-adhd/SKILL.md"

local function strip_frontmatter(text)
  if not text:find("^%-%-%-[ \t]*\r?\n") then
    return text
  end
  local _, close = text:find("\n%-%-%-[ \t]*\r?\n")
  if not close then
    return text
  end
  return text:sub(close + 1)
end

local raw, err = maki.fs.read(SKILL_PATH)
if not raw then
  maki.log.warn("i-have-adhd hint skipped, cannot read " .. SKILL_PATH .. ": " .. tostring(err))
  return
end

local body = strip_frontmatter(raw):match("^%s*(.-)%s*$")
if #body == 0 then
  maki.log.warn("i-have-adhd hint skipped, " .. SKILL_PATH .. " has an empty body")
  return
end

maki.api.register_prompt_hint({
  slot = "after_instructions",
  prompt = "system",
  content = body,
})
