-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- `/resume` as an alias for the built-in session picker.
maki.api.register_command({
  name = "/resume",
  description = "Alias for /sessions",
  handler = function()
    local ok, err = maki.api.run_command("/sessions")
    if not ok then
      maki.ui.flash("could not run /sessions: " .. err)
    end
  end,
})
