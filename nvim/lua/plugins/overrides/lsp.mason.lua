---@type LazySpec
return {
  [1] = "mason.nvim",
  optional = true,
  ---@type MasonSettings
  opts = {
    PATH = "append", -- Mason's bin location is put at the end of PATH
  },
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "mason.nvim" },
      },
    },
  },
}
