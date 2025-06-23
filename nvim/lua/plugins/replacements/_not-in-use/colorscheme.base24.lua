---@type LazySpec[]
return {
  {
    [1] = "tinted-theming/tinted-nvim",
    lazy = false,
    priority = 999999999,
    config = function()
      vim.opt.termguicolors = true
      require("tinted-colorscheme").setup(require("_base24"))
    end,
  },
  -- {
  --   [1] = "LazyVim/LazyVim",
  --   optional = true,
  --   opts = {
  --     colorscheme = "modus",
  --   },
  -- },
}
