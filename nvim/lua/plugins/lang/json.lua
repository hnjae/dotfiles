return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("plugins.core.treesitter.languages"):add("json", "jsonc", "json5")
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        jsonls = {
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
}
