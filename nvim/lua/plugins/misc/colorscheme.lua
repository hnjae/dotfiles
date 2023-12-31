-- colorscheme
-- https://github.com/folke/lsp-colors.nvim

return {
  {
    [1] = "Mofiqul/vscode.nvim",
    -- NOTE: does not support htmlH1 (2022-06-21)
    lazy = false,
    enabled = true,
    priority = 999999999,
    opts = {
      italic_comments = true,
    },
    init = function()
      vim.o.background = "dark"
      vim.g.vscode_style = vim.o.background
    end,
    config = function()
      vim.cmd([[colorscheme vscode]])
    end,
  },
  {
    [1] = "toppair/prospector.nvim",
    lazy = false,
    enabled = false,
    priority = 99999999999,
    -- dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("prospector").setup()
      vim.cmd("colorscheme prospector_darker")
    end,
  },
  {
    [1] = "kvrohit/rasmus.nvim",
    lazy = false,
    enabled = false,
    priority = 999999999,
    init = function()
      vim.g.rasmus_italic_functions = true
      vim.g.rasmus_bold_functions = true
    end,
    config = function()
      vim.cmd([[colorscheme rasmus]])
    end,
  },
  {
    [1] = "Mofiqul/adwaita.nvim",
    lazy = false,
    enabled = false,
    priority = 999999999,
    config = function()
      vim.g.adwaita_darker = true -- for darker version
      vim.g.adwaita_disable_cursorline = true -- to disable cursorline
      vim.cmd([[colorscheme adwaita]])
    end,
  },
  {
    [1] = "marko-cerovac/material.nvim",
    lazy = false,
    enabled = false,
  },
  {
    [1] = "ellisonleao/gruvbox.nvim",
    lazy = false,
    enabled = false,
  },
  {
    [1] = "projekt0n/github-nvim-theme",
    lazy = false,
    enabled = false,
  },
  {
    [1] = "rafamadriz/neon",
    lazy = false,
    enabled = false,
  },
}
