-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    table.insert(opts.sections.lualine_b, "overseer")
  end,
}

---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  specs = { spec },
}
