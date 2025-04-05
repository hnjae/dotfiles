---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("plugins.core.treesitter.languages"):add(
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
    dependencies = {},
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
    -- neodev.nvim replacement
    [1] = "folke/lazydev.nvim",
    lazy = true,
    cond = true,
    enabled = true,
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        "which-key.nvim",

        -- Only load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
    specs = {
      { [1] = "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
      {
        [1] = "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(_, opts)
          opts.sources = opts.sources or {}
          table.insert(opts.sources, {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          })
        end,
      },
    },
  },
  {
    [1] = "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { [1] = "hrsh7th/cmp-nvim-lua" }, -- auto complete neovim's Lua runtime API e.g.) vim.*
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "nvim_lua", group_index = 1 })
    end,
  },
}
