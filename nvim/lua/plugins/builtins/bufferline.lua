---@type LazySpec
return {
  [1] = "akinsho/bufferline.nvim",
  optional = true,

  -- disable lazyvim's mapping
  keys = {
    { "<S-h>", "<Nop>" },
    { "<S-l>", "<Nop>" },
  },
}
