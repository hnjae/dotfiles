--[[
  NOTE: <2024-05-16>

  gruvbox.nvim 는 vim.opt.background 값에 맞춰서 알아서 설정됨.

  Supports:
    - blink.nvim
    - gitsigns
    - treesitter

    - telescope
    - navic
    - rainbow-delimiter
    - mini
    - coc, NvimTree, Startify, NERDTree

  Does not supports (2025-04-06):
    - lualine
    - fzf-lua
]]

---@type LazySpec[]
return {
  -- add gruvbox
  {
    [1] = "ellisonleao/gruvbox.nvim",
    version = false, -- use the latest git commit
    opts = {
      -- transparent_mode = true,
      -- dim_inactive = true,
      underline = false,
      terminal_colors = os.getenv("BASE16_THEME") == nil,
      overrides = {
        -- NormalFloat = { bg = "none" },
      },
    },
  },

  -- Configure LazyVim to load gruvbox
  {
    [1] = "LazyVim/LazyVim",
    optional = true,
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
