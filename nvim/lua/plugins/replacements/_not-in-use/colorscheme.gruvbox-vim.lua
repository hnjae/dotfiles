---@type LazySpec[]
return {
  {
    [1] = "morhetz/gruvbox",
    lazy = false,
    priority = 999999999,
  },
  {
    [1] = "LazyVim/LazyVim",
    optional = true,
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
