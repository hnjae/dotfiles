  -- colorscheme
return {
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority=999999999,
    config = function()
      -- does not support htmlH1 (2022-06-21)
      vim.o.background = 'dark'
      vim.g.vscode_style = "dark"
      -- vim.g.vscode_italic_comment = 1
      -- vim.cmd([[silent! colorscheme vscode]])
      require('vscode').setup({
        italic_comments = true,
      })
    end
  },
  {
    'toppair/prospector.nvim',
    lazy = true,
    dependenceis = { 'nvim-treesitter/nvim-treesitter' }
  },
  { 'projekt0n/github-nvim-theme', lazy = true },
  { 'rafamadriz/neon', lazy = true },
  { 'kvrohit/rasmus.nvim', lazy = true },
  { 'Mofiqul/adwaita.nvim', lazy = true },
  { 'marko-cerovac/material.nvim', lazy = true },
  { 'ellisonleao/gruvbox.nvim', lazy = true },
}
