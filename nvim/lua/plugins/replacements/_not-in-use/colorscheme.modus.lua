---@type LazySpec[]
return {
  {
    [1] = "miikanissi/modus-themes.nvim",
    lazy = false,
    priority = 999999999,
    opts = {},
  },
  {
    [1] = "LazyVim/LazyVim",
    optional = true,
    opts = {
      colorscheme = "modus",
    },
  },
}
