---@type LazySpec[]
return {
  {
    [1] = "mason.nvim",
    optional = true,
    ---@type MasonSettings
    opts = {
      PATH = "append", -- Mason's bin location is put at the end of PATH
      max_concurrent_installers = 3, -- default: 4
    },
    specs = {},
  },
  {
    [1] = "mason-lspconfig.nvim",
    optional = true,
    opts = {
      automatic_enable = {
        exclude = { "nil_ls" },
      },
    },
  },
}
