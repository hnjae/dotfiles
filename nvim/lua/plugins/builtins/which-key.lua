---@type LazySpec
return {
  [1] = "which-key.nvim",
  opts_extend = { "spec", "icons.rules" },
  optional = true,
  opts = {
    -- preset = "helix",
  },
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = {
          "which-key.nvim",
        },
      },
    },
  },
}
