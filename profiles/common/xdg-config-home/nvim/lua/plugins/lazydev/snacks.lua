---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "snacks.nvim" },
      },
    },
  },
}
