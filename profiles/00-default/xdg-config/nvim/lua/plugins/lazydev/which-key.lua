---@type LazySpec
return {
  [1] = "which-key.nvim",
  optional = true,
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "which-key.nvim" },
      },
    },
  },
}
