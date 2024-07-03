-- It's important that you set up neoconf.nvim BEFORE nvim-lspconfig.

---@type LazySpec
return {
  [1] = "folke/neoconf.nvim",
  lazy = true,
  event = { "VeryLazy" },
  enabled = require("utils").is_treesitter,
  opts = {
    local_settings = ".neoconf.json",
    global_settings = "neoconf.json",
    import = {
      vscode = false,
      coc = false,
      nlsp = false,
    },

    -- requires treesitter's jsonc parser installed
    filetype_jsonc = true,
  },
  specs = {
    {
      [1] = "neovim/nvim-lspconfig",
      optional = true,
      dependencies = {
        "folke/neoconf.nvim",
      },
    },
  },
}
