-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- LazyExtra's ai.sidekick

---@type LazySpec
return {
  [1] = "sidekick.nvim",
  cond = not vim.g.vscode,
  opts = {
    nes = { enabled = false }, -- NES 는 리팩토링 용도. copilot 과는 목적이 다르다고.
  },
}
