-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Document how maki relays `!` shell commands, so the agent does not claim
-- their output is invisible to it.
maki.api.register_prompt_hint({
  slot = "tool_usage",
  content = "- A line submitted with a leading `!` runs a shell command, and its result reaches you on the next turn as a user message shaped `I ran: $ <command>` followed by `Output:` or `Error:`. A `!!` line runs the same way but hides the result from you. Never tell the user that `!` output does not reach you.",
})
