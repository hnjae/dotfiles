---@type LazySpec
return {
  [1] = "folke/lazy.nvim",
  optional = true,
  specs = {
    {
      [1] = "folke/lazydev.nvim",
      optional = true,
      opts = {
        library = {
          "lazy.nvim",
        },
      },
    },
  },
}
