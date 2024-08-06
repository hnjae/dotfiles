---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("yaml")
    end,
  },
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      if require("utils").lsp.is_prettier() then
        if vim.fn.executable("prettierd") == 1 then
          opts.formatters_by_ft.yaml = { "prettierd" }
        else
          opts.formatters_by_ft.yaml = { "prettier" }
        end

        return
      end

      opts.formatters_by_ft.yaml = { "yamlfmt" }
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {},
    opts = {
      servers = {
        yamlls = {
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
}
