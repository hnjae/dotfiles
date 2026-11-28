-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- Shared by the goal specs. Each spec runs without maki:
--   luajit tests/goal_state_spec.lua
--   luajit tests/goal_transcript_spec.lua

local M = { passed = 0, failed = 0 }

function M.case(name, fn)
  local ok, err = pcall(fn)
  if ok then
    M.passed = M.passed + 1
    return
  end
  M.failed = M.failed + 1
  io.stderr:write("FAIL " .. name .. ": " .. tostring(err) .. "\n")
end

function M.eq(actual, expected, label)
  if actual ~= expected then
    error(
      (label or "value") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual),
      2
    )
  end
end

function M.match(value, pattern, label)
  if type(value) ~= "string" or not value:match(pattern) then
    error((label or "value") .. ": expected " .. pattern .. ", got " .. tostring(value), 2)
  end
end

function M.truthy(value, label)
  if not value then
    error(label or "expected a value", 2)
  end
end

function M.missing(value, err, label)
  if value ~= nil then
    error((label or "value") .. ": expected nil, got " .. tostring(value), 2)
  end
  if err == nil then
    error((label or "value") .. ": expected an error", 2)
  end
end

function M.report()
  print(string.format("%d passed, %d failed", M.passed, M.failed))
  os.exit(M.failed == 0 and 0 or 1)
end

return M
