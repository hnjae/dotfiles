---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  specs = {
    {
      [1] = "folke/lazydev.nvim",
      optional = true,
      opts = {
        library = { "snacks.nvim" },
      },
    },
  },
}
