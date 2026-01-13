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
}
