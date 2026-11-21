-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

--[[
  NOTE:
    Overrides `go.nix` from LazyExtra
--]]

---@type LazySpec[]
return {
  {
    [1] = "nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      if vim.fn.executable("go") ~= 1 then
        opts.servers.gopls = nil
      end
    end,
  },
}
