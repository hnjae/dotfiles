---@type LazySpec
return {
  [1] = "mason.nvim",
  optional = true,
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
