---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("plugins.core.treesitter.languages"):add("prisma")
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {},
    opts = {
      servers = {
        -- npm install -g @prisma/language-server
        prismals = {
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
}
