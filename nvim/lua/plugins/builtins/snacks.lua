---@type LazySpec
return {
  [1] = "folke/snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {},
  specs = {
    {
      [1] = "folke/lazydev.nvim",
      optional = true,
      opts = {
        library = {
          "snacks.nvim",
        },
      },
    },
  },
}
