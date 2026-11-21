-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Quickphrase "dt": inserts the current local date or time.
-- Argument: "" date, "t" time, "i" ISO 8601 date-time, "w" ISO week date, else locale default.

local formats = {
  [""] = "%Y-%m-%d",
  t = "%H:%M:%S",
  i = "%Y-%m-%dT%H:%M:%S%z",
  w = "%G-W%V-%u",
}

function LookupDate(arg)
  local text = os.date(formats[arg] or "%c")
  if arg == "i" then
    -- %z yields +0900; ISO 8601 extended form wants +09:00.
    -- Parentheses drop gsub's second return value (the substitution count).
    text = (text:gsub("([+-]%d%d)(%d%d)$", "%1:%2"))
  end
  return text
end

ime.register_command("dt", "LookupDate", "날짜·시간 입력")
