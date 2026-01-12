---@type LazySpec[]
return {
  {
    [1] = "mason.nvim",
    optional = true,
    ---@type MasonSettings
    opts = {
      PATH = "append", -- Mason's bin location is put at the end of PATH
    },
    specs = {},
  },
  {
    [1] = "mason-lspconfig.nvim",
    optional = true,
    enabled = vim.fn.executable("cc") == 1 or vim.fn.executable("clang") == 1,
  },
}
