---@type LazySpec[]
return {
  -- TODO: make following to support *.kdl, *.toml <2023-02-04, Hyunjae Kim>
  -- TODO: check: https://github.com/brenoprata10/nvim-highlight-colors
  -- { "ap/vim-css-color" }, -- preview color

  -- {
  --   [1] = "NvChad/nvim-colorizer.lua",
  --   enabled = vim.opt.termguicolors:get(),
  --   lazy = true,
  --   ft = {
  --     "css",
  --   },
  --   opts = {
  --     user_default_options = {
  --       filetypes = {
  --         "css",
  --       },
  --       tailwind = "both",
  --     },
  --   },
  -- },

  {
    [1] = "brenoprata10/nvim-highlight-colors",
    cond = not vim.g.vscode and vim.opt.termguicolors:get(),
    lazy = true,
    event = "VeryLazy",
    cmd = {
      "HighlightColors",
    },
    opts = {
      enable_tailwind = true,
    },
  },
}
