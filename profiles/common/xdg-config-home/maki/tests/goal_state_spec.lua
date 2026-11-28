-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- state.lua is pure, so this runs without maki:
--   luajit tests/goal_state_spec.lua

local here = (arg[0]:match("^(.*)/[^/]*$") or ".")
local S = dofile(here .. "/../lua/plugins/goal/state.lua")

local LIMITS = { rounds = 50, stalls = 3 }
local h = dofile(here .. "/harness.lua")
local case, eq, match, truthy, missing = h.case, h.eq, h.match, h.truthy, h.missing

local function record(overrides)
  local goal = S.new_goal("goal-1", "exec-1", "ship it", 100)
  for key, value in pairs(overrides or {}) do
    goal[key] = value
  end
  return goal
end

case("a new goal starts active with zero counters", function()
  local goal = record()
  eq(goal.status, "active")
  eq(goal.rounds, 0)
  eq(goal.stalls, 0)
  eq(goal.summary, nil)
  eq(goal.audit_reason, nil)
  truthy(S.validate_record(goal))
end)

case("validation rejects unknown fields and bad values", function()
  missing(S.validate_record(record({ extra = true })))
  missing(S.validate_record(record({ rounds = -1 })))
  missing(S.validate_record(record({ rounds = 1.5 })))
  missing(S.validate_record(record({ status = "bogus" })))
  missing(S.validate_record(record({ summary = "done" })))
  missing(S.validate_record(record({ status = "complete" })))
  truthy(S.validate_record(record({ status = "auditing", summary = "done" })))
end)

case("document validation ties the session id to the file", function()
  local goal = record()
  truthy(S.validate_document({ version = 1, session_id = "s1", goal = goal }, "s1"))
  missing(S.validate_document({ version = 1, session_id = "s2", goal = goal }, "s1"))
  missing(S.validate_document({ version = 2, session_id = "s1", goal = goal }, "s1"))
  missing(S.validate_document({ version = 1, session_id = "s1", goal = goal, extra = 1 }, "s1"))
end)

case("complete requires an active goal, matching ids, and a summary", function()
  local goal = record()
  missing(S.request_complete(goal, "goal-1", "exec-1", " ", 200))
  missing(S.request_complete(goal, "goal-1", "exec-2", "done", 200))
  local auditing = S.request_complete(goal, "goal-1", "exec-1", "done", 200)
  eq(auditing.status, "auditing")
  eq(auditing.summary, "done")
  eq(auditing.updated_at, 200)
  missing(S.request_complete(auditing, "goal-1", "exec-1", "again", 300))
end)

case("audit approval completes and clears the reason", function()
  local auditing = S.request_complete(record(), "goal-1", "exec-1", "done", 200)
  auditing.audit_reason = "earlier"
  local complete = S.audit_approved(auditing, "goal-1", "exec-1", 300)
  eq(complete.status, "complete")
  eq(complete.summary, "done")
  eq(complete.audit_reason, nil)
  missing(S.audit_approved(record(), "goal-1", "exec-1", 300))
end)

case("audit rejection returns to active and keeps the reason", function()
  local auditing = S.request_complete(record(), "goal-1", "exec-1", "done", 200)
  local active = S.audit_rejected(auditing, "goal-1", "exec-1", "tests fail", 300)
  eq(active.status, "active")
  eq(active.summary, nil)
  eq(active.audit_reason, "tests fail")
  match(S.audit_rejected(auditing, "goal-1", "exec-1", "", 300).audit_reason, "%S")
  missing(S.audit_rejected(record(), "goal-1", "exec-1", "x", 300))
end)

case("pause and resume follow the terminal rules", function()
  local paused = S.pause(record({ rounds = 4, stalls = 2, audit_reason = "r" }), 200)
  eq(paused.status, "paused")
  eq(paused.audit_reason, nil)
  missing(S.pause(paused, 300))
  missing(S.pause(record({ status = "complete", summary = "done" }), 300))

  local resumed = S.resume(paused, "exec-2", 300)
  eq(resumed.status, "active")
  eq(resumed.execution_id, "exec-2")
  eq(resumed.rounds, 0)
  eq(resumed.stalls, 0)
  missing(S.resume(record({ status = "complete", summary = "done" }), "e", 300))
  missing(S.resume(record({ status = "auditing", summary = "s" }), "e", 300))

  local forced = S.force_pause(record(), "stopped", 300)
  eq(forced.status, "paused")
  eq(forced.audit_reason, "stopped")
  missing(S.force_pause(record({ status = "complete", summary = "done" }), "x", 300))
end)

case("after_turn ignores another execution or a non-active goal", function()
  eq(S.after_turn(record(), "other", true, LIMITS, 200), nil)
  eq(S.after_turn(record({ status = "paused" }), "exec-1", true, LIMITS, 200), nil)
end)

case("a turn with tools counts a round and resets stalls", function()
  local next_record, decision = S.after_turn(record({ stalls = 2 }), "exec-1", true, LIMITS, 200)
  eq(decision, "continue")
  eq(next_record.rounds, 1)
  eq(next_record.stalls, 0)
  eq(next_record.updated_at, 200)
end)

case("three tool-less turns pause without counting the last round", function()
  local next_record, decision =
    S.after_turn(record({ stalls = 2, rounds = 5 }), "exec-1", false, LIMITS, 200)
  eq(decision, "paused")
  eq(next_record.status, "paused")
  eq(next_record.stalls, 3)
  eq(next_record.rounds, 5)
  match(next_record.audit_reason, "no tool calls")
end)

case("the round cap pauses on the 50th turn", function()
  local paused, decision = S.after_turn(record({ rounds = 49 }), "exec-1", true, LIMITS, 200)
  eq(decision, "paused")
  eq(paused.rounds, 50)
  local continued, next_decision =
    S.after_turn(record({ rounds = 48 }), "exec-1", true, LIMITS, 200)
  eq(next_decision, "continue")
  eq(continued.rounds, 49)
end)

case("matches compares both identifiers", function()
  truthy(S.matches(record(), "goal-1", "exec-1"))
  eq(S.matches(record(), "goal-1", "exec-2"), false)
  eq(S.matches(nil, "goal-1", "exec-1"), false)
end)

case("format and hint describe every state", function()
  match(S.format(nil, false, 50), "No goal")
  match(S.format(record(), true, 50), "interrupted")
  match(S.format(record(), false, 50), "Rounds: 0/50")
  eq(S.hint(nil, false, 50), nil)
  match(S.hint(record(), true, 50), "interrupted")
  match(S.hint(record({ rounds = 3 }), false, 50), "3/50")
  match(S.hint(record({ status = "auditing", summary = "s" }), false, 50), "auditing")
  match(S.hint(record({ status = "paused" }), false, 50), "paused")
  match(S.hint(record({ status = "complete", summary = "s" }), false, 50), "achieved")
end)

case("state paths are confined to safe session ids", function()
  eq(S.session_filename("ChV89EL92Ejg6NqvBpdtB"), "ChV89EL92Ejg6NqvBpdtB.json")
  missing(S.session_filename("../x"))
  missing(S.session_filename(""))
  missing(S.session_filename(("a"):rep(129)))
  eq(S.state_path("/state", "abc"), "/state/local.goal/abc.json")
  eq(S.joinpath("/state/", "x"), "/state/x")
end)

case("the state directory falls back to XDG and HOME", function()
  eq(
    S.resolve_state_dir("/given", function()
      return "/env"
    end),
    "/given"
  )
  eq(
    S.resolve_state_dir(nil, function(name)
      return name == "XDG_STATE_HOME" and "/xdg" or nil
    end),
    "/xdg/maki"
  )
  eq(
    S.resolve_state_dir(nil, function(name)
      return name == "HOME" and "/home/u" or nil
    end),
    "/home/u/.local/state/maki"
  )
  local dir, err = S.resolve_state_dir(nil, function()
    return nil
  end)
  eq(dir, nil)
  truthy(err)
end)

h.report()
