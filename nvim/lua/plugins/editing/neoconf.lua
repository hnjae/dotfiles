---@type LazyPluginSpec
local spec = {
  [1] = "folke/neoconf.nvim",
  lazy = true,
  event = { "VeryLazy" },
  cond = require("utils").is_treesitter,
  opts = {
    local_settings = ".neoconf.json",
    global_settings = "resources/neoconf.json",
    import = {
      vscode = false,
      coc = false,
      nlsp = false,
    },

    -- requires treesitter's jsonc parser installed
    filetype_jsonc = true,
  },
  specs = {},
}

---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  dependencies = {
    -- It's important that you set up neoconf.nvim BEFORE nvim-lspconfig.
    spec,
  },
}
