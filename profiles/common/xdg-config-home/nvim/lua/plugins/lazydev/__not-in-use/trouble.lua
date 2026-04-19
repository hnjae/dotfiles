---@type LazySpec
return {
  [1] = "trouble.nvim",
  optional = true,
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "trouble.nvim" },
      },
    },
  },
}
