---@type LazySpec[]
return {
  {
    [1] = "webhooked/kanso.nvim",
    lazy = false,
    version = false,
    priority = 999999999,
    opts = {},
  },
  {
    [1] = "LazyVim/LazyVim",
    optional = true,
    opts = {
      colorscheme = "kanso",
    },
  },
}
