---@type LazySpec
return {
  [1] = "folke/snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    words = {
      enabled = false,
      foldopen = false,
      jumplist = false,
    },
  },
  specs = {},
}
