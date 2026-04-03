---@type LazySpec
return {
  [1] = "noice.nvim",
  optional = true,
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "noice.nvim" },
      },
    },
  },
}
