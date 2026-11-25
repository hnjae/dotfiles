-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Show the input mode in the status bar, so normal mode is visible.
-- The label is empty on purpose: the mode name is the whole message.
local function show_mode()
  if maki.fn.mode() == "n" then
    maki.ui.set_status_hint({ { "NORMAL", "" } })
  else
    maki.ui.set_status_hint({ { "INPUT", "" } })
  end
end

maki.api.create_autocmd("ModeChanged", { callback = show_mode })
