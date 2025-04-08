---@type LazySpec
return {
  [1] = "bufferline.nvim",
  optional = true,

  opts = {
    options = {
      -- single buffer with multiple tabs won't show bufferline by default (2025-04-08)
      always_show_bufferline = true,
    },
  },

  -- disable lazyvim's mapping
  keys = {
    { "<S-h>", "<Nop>" },
    { "<S-l>", "<Nop>" },
  },
}
