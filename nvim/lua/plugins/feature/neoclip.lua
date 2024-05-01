---@type LazySpec[]
return {
  {
    [1] = "AckslD/nvim-neoclip.lua",
    lazy = true,
    event = "VeryLazy",
    opts = {
      history = 100,
      enable_persistent_history = false,
      enable_macro_history = false,
    },
  },
  {
    [1] = "nvim-telescope/telescope.nvim",
    optional = true,
    keys = {
      {
        [1] = "<Leader>p",
        [2] = "<cmd>Telescope neoclip<CR>",
        desc = "neoclip",
      },
    },
  },
}
