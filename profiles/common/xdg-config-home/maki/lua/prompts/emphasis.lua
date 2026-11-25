-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- Make replies scannable with status markers, in the spirit of pi-emphasis.
--
-- Maki opens no slot around assistant message rendering, so the colored
-- pills, per-word theme colors and icon substitution of the Pi extension
-- cannot be reproduced: `maki.ui.markdown` only draws into a buffer a
-- plugin owns. What is portable is the half that asks the model for a fixed
-- vocabulary. The terminal colors the emoji itself, which is the only color
-- a plugin can put into the transcript.
--
-- `after_instructions` is an aggregate slot and `system.md` ends with it, so
-- the rules sit at the very end of the prompt, after the project
-- instructions. `prompt = "system"` keeps them out of the research and
-- general subagent prompts, which write tool results rather than replies.
--
-- Prompt hints are ungated, so plugin.toml needs no new permission.

local GUIDANCE = [[
## Reply markers

This section is the explicit request the tone rules ask for: use the emoji below only as reply markers, nowhere else.

- Open a reply with the marker for where the work stands: ✅ done, ❌ failed, ⚠️ needs you, ⏳ in progress, 🔍 unverified.
- Put a marker immediately before the thing it describes. After ⚠️, ❌ or 🔍, state the action it calls for on the same or the next line.
- Mark a claim you have not checked with 🔍, and say what would check it.
- Mark consequences only when they apply: 💰 costs money, 🗑️ destructive or irreversible.
- Give a long reply ## headings or bold lead labels (**Result:**, **Cause:**, **Next:**).
- Never put a marker in fenced or inline code, quoted tool output, or a file path.]]

maki.api.register_prompt_hint({
  slot = "after_instructions",
  prompt = "system",
  content = GUIDANCE,
})
