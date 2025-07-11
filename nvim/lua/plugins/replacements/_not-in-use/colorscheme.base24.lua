---@type LazySpec[]
return {
  {
    [1] = "tinted-theming/tinted-nvim",
    lazy = false,
    cond = vim.fn.executable("tinty") == 1,
    priority = 999999999,
    main = "colorscheme",
    opts = require("_base24"),
  },
  -- {
  --   [1] = "LazyVim/LazyVim",
  --   optional = true,
  --   opts = {
  --     colorscheme = "modus",
  --   },
  -- },
}
