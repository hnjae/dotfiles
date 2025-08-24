---@type LazySpec
return {
  [1] = "grug-far.nvim",
  optional = true,
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "grug-far.nvim" },
      },
    },
  },
}
