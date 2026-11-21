--- @sync entry

-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

return {
  entry = function()
    ya.emit("sort", { reverse = cx.active.pref.sort_reverse and "no" or "yes" })
  end,
}
