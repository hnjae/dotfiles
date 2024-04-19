---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("css")
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {},
    opts = {
      servers = {
        cssls = {
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
}
