-- colorscheme
return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    enabled = true,
    priority = 999999999,
    config = function()
      -- NOTE: does not support htmlH1 (2022-06-21)
      vim.o.background = "dark"
      vim.g.vscode_style = "dark"
      -- vim.g.vscode_italic_comment = 1
      -- vim.cmd([[silent! colorscheme vscode]])
      require("vscode").setup({
        italic_comments = true,
      })
    end,
  },
  {
    "toppair/prospector.nvim",
    lazy = false,
    enabled = false,
    priority = 99999999999,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("prospector").setup()
      vim.cmd("colorscheme prospector_darker")
    end,
  },
  {
    "kvrohit/rasmus.nvim",
    lazy = false,
    enabled = false,
    priority = 999999999,
    config = function()
      vim.g.rasmus_italic_functions = true
      vim.g.rasmus_bold_functions = true
      vim.cmd([[colorscheme rasmus]])
    end,
  },
  {
    "Mofiqul/adwaita.nvim",
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
    "marko-cerovac/material.nvim",
    lazy = false,
    enabled = false,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    enabled = false,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    enabled = false,
  },
  {
    "rafamadriz/neon",
    lazy = false,
    enabled = false,
  },
}
