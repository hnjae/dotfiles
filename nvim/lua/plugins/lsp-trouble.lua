return {
  -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
  "folke/trouble.nvim",
  lazy = false,
  -- event = {},
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "neovim/nvim-lspconfig",
  },
}
