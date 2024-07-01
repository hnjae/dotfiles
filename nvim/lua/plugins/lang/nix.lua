---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("nix")
    end,
  },
  {
    -- :h conform-formatters
    -- https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      -- nix = { { "alejandra", "nixpkgs_fmt", "nixfmt" } },
      opts.formatters_by_ft.nix = {
        "alejandra",
      }
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        -- NOTE: archived projects <2024-01-26>
        -- rnix = {
        --   ---@class LspconfigSetupOptsSpec
        --   settings = {},
        -- },
        nil_ls = {
          -- https://github.com/oxalica/nil
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
        nixd = {
          -- https://github.com/nix-community/nixd/blob/main/nixd/docs/editors/nvim-lsp.nix
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
  {
    [1] = "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require("null-ls")

      local mapping = {
        statix = {
          null_ls.builtins.diagnostics.statix,
          null_ls.builtins.code_actions.statix,
        },
        -- scan dead code
        deadnix = { null_ls.builtins.diagnostics.deadnix },
      }

      for exe, sources in pairs(mapping) do
        if vim.fn.executable(exe) == 1 then
          vim.list_extend(opts.sources, sources)
        end
      end
    end,
  },
}
