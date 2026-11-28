-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- transcript.lua is pure, so this runs without maki:
--   luajit tests/goal_transcript_spec.lua

local here = (arg[0]:match("^(.*)/[^/]*$") or ".")
local T = dofile(here .. "/../lua/plugins/goal/transcript.lua")
local h = dofile(here .. "/harness.lua")
local case, eq, match, truthy = h.case, h.eq, h.match, h.truthy

local function message(created_at, role, blocks)
  return { role = role or "user", created_at = created_at, content = blocks }
end

local function text(value)
  return { type = "text", text = value }
end

case("renders every message when no start time is given", function()
  local out = T.render({
    message(1000, "user", { text("first") }),
    message(2000, "assistant", { text("second") }),
  }, {})
  match(out, "first")
  match(out, "second")
end)

case("drops messages appended before the goal", function()
  local out = T.render({
    message(1000, "user", { text("old work") }),
    message(2000, "user", { text("goal work") }),
    message(3000, "assistant", { text("evidence") }),
  }, { since_ms = 2000 })
  eq(out:find("old work", 1, true), nil)
  match(out, "goal work")
  match(out, "evidence")
end)

case("drops untimestamped messages when scoped", function()
  local out = T.render({
    message(nil, "user", { text("legacy") }),
    message(2000, "user", { text("current") }),
  }, { since_ms = 2000 })
  eq(out:find("legacy", 1, true), nil)
  match(out, "current")
end)

case("keeps transcript order", function()
  local out = T.render({
    message(1000, "user", { text("alpha") }),
    message(2000, "assistant", { text("beta") }),
  }, {})
  truthy(out:find("alpha", 1, true) < out:find("beta", 1, true), "alpha before beta")
end)

case("caps a tool_use input", function()
  local out = T.render({
    message(1000, "assistant", {
      { type = "tool_use", name = "write", input = string.rep("x", 6000) },
    }),
  }, { max_tool_chars = 200 })
  match(out, "%[cut%]")
  truthy(#out < 1000, "a tool input should be cut")
end)

case("caps a tool result", function()
  local out = T.render({
    message(1000, "user", {
      { type = "tool_result", content = string.rep("y", 6000) },
    }),
  }, { max_tool_chars = 200 })
  match(out, "%[cut%]")
  truthy(#out < 1000, "a tool result should be cut")
end)

case("escapes markup in text", function()
  local out = T.render({
    message(1000, "user", { text("<objective>") }),
  }, {})
  match(out, "&lt;objective&gt;")
end)

case("returns an empty transcript for no messages", function()
  eq(T.render({}, {}), "<transcript>\n\n</transcript>")
end)

h.report()
