-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add(
        "lua",
        "luadoc",
        "luap", -- https://www.lua.org/pil/20.2.html
        "luau"
      )
    end,
  },
  {
    [1] = "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require("null-ls")

      local mapping = {
        selene = { null_ls.builtins.diagnostics.selene }, -- lua linter written in rust
      }

      for exe, sources in pairs(mapping) do
        if vim.fn.executable(exe) == 1 then
          vim.list_extend(opts.sources, sources)
        end
      end
    end,
  },
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      -- stylua:  lua formatter written in rust
      opts.formatters_by_ft.lua = { "stylua" }
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {
      "folke/neodev.nvim",
    },
    opts = {
      servers = {
        lua_ls = {
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
  {
    [1] = "folke/neodev.nvim",
    enabled = true,
    lazy = true,
    opts = {},
  },
  {
    [1] = "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { [1] = "hrsh7th/cmp-nvim-lua" }, -- auto complete neovim's Lua runtime API e.g.) vim.*
    },
    opts = function(_, opts)
      if opts.sources == nil then
        opts.sources = {}
      end
      table.insert(opts.sources, { name = "nvim_lua", group_index = 1 })
    end,
  },
}
