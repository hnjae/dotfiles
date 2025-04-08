---@type LazySpec
return {
  [1] = "bufferline.nvim",
  optional = true,

  -- disable lazyvim's mapping
  keys = {
    { "<S-h>", "<Nop>" },
    { "<S-l>", "<Nop>" },
  },
}
