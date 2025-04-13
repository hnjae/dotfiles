---@type LazySpec[]
return {
  {
    [1] = "catppuccin/nvim",
    lazy = false,
    priority = 999999999,
    opts = {},
  },
  {
    [1] = "LazyVim/LazyVim",
    optional = true,
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
