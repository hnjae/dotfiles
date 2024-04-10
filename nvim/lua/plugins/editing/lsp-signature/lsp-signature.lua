---@type LazySpec[]
return {
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  dependencies = {
    {
      -- shows popup window about parameter/func
      -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
      -- can be replaced by noice (or cmp-nvim-lsp-signature-help)
      -- either does not open popup permanently while typing
      [1] = "ray-x/lsp_signature.nvim",
      lazy = true,
      opts = {
        -- fix_pos = false,
      },
      enabled = true,
    },
  },
}
