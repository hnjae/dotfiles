---@type LazySpec
return {
  [1] = "nvim-cmp",
  optional = true,
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "nvim-cmp" },
      },
    },
  },
}
