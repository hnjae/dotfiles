---@type LazySpec
return {
  [1] = "lazy.nvim",
  optional = true,
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = {
          "lazy.nvim",
        },
      },
    },
  },
}
