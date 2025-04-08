-- NOTE: use S in visual-mode <2024-05-09>

---@type LazySpec
return {
  [1] = "kylechui/nvim-surround",
  lazy = true,
  version = "*",
  event = { "VeryLazy" },
  opts = {},
  dependencies = {
    {
      -- to override keys of flash.nvim
      [1] = "folke/flash.nvim",
      optional = true,
    },
  },
  specs = {},
}
