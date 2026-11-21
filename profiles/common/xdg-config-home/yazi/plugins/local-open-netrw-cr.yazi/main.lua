--- @sync entry

-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

return {
  entry = function()
    local hovered = cx.active.current.hovered
    if not hovered then
      return
    end

    if hovered.cha.is_dir then
      ya.emit("enter", {})
      return
    end

    ya.emit("open", { hovered = true })
  end,
}
