---@type LazySpec
return {
  [1] = "folke/which-key.nvim",
  opts_extend = { "spec", "icons.rules" },
  optional = true,
  opts = {
    -- preset = "helix",
  },
  specs = {
    {
      [1] = "folke/lazydev.nvim",
      optional = true,
      opts = {
        library = {
          "which-key.nvim",
        },
      },
    },
  },
}
