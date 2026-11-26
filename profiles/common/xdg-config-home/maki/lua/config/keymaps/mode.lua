-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Thinking level each mode runs at. Plan mode reasons about the whole change,
-- so it gets the top rung; build mode executes and only needs the level a new
-- session starts at (`always_thinking` in config/options.lua).
local mode_thinking = { plan = "max", build = "high" }

-- Flip between plan and build. `<Tab>` is swallowed below so this is the
-- only key that switches modes.
local function toggle_mode()
  local info, err = maki.session.read()
  if not info then
    maki.notify("Mode switch failed: " .. tostring(err), "warn", { title = "maki" })
    return
  end
  local next_mode = info.mode == "plan" and "build" or "plan"
  local ok, set_err = maki.session.set_mode(next_mode)
  if not ok then
    maki.notify("Mode switch failed: " .. tostring(set_err), "warn", { title = "maki" })
    return
  end
  -- A model that lacks the top rung snaps down, so a failure here is the only
  -- thing worth reporting; `maki.model.get().thinking_shown` names the result.
  local _, think_err = maki.model.set({ thinking = mode_thinking[next_mode] })
  if think_err then
    maki.notify("Thinking switch failed: " .. tostring(think_err), "warn", { title = "maki" })
  end
end

maki.keymap.set({ "n", "i" }, "<S-Tab>", toggle_mode, { desc = "Toggle plan/build mode" })

-- Take `<Tab>` away from the stock plan/build switch. Not calling
-- `ev.fallback()` is what stops Maki's own handling.
maki.keymap.set({ "n", "i" }, "<Tab>", function() end, { desc = "Disabled" })
