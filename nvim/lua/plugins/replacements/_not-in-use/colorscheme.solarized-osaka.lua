--[[
  NOTE: <2024-05-16>

  gruvbox.nvim 는 vim.opt.background 값에 맞춰서 알아서 설정됨.

  Supports (2025-04-06):
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
    [1] = "craftzdog/solarized-osaka.nvim",
    version = false, -- use the latest git commit
    opts = {
      -- style = "day",
      transparent = "true",
    },
  },

  -- {
  --   [1] = "ibhagwan/fzf-lua",
  --   optional = true,
  --   opts = {
  --     fzf_colors = {
  --       true,
  --       -- ["fg"] = { "fg", "CursorLine" },
  --       -- ["bg"] = { "bg", "Normal" },
  --       -- ["hl"] = { "fg", "Comment" },
  --       -- ["fg+"] = { "fg", "Normal", "underline" },
  --       -- ["bg+"] = { "bg", { "CursorLine", "Normal" } },
  --       -- ["hl+"] = { "fg", "Statement" },
  --       -- ["info"] = { "fg", "PreProc" },
  --       -- ["prompt"] = { "fg", "Conditional" },
  --       -- ["pointer"] = { "fg", "Exception" },
  --       -- ["marker"] = { "fg", "Keyword" },
  --       -- ["spinner"] = { "fg", "Label" },
  --       -- ["header"] = { "fg", "Comment" },
  --       -- ["gutter"] = "-1",
  --     },
  --   },
  -- },

  -- Configure LazyVim to load gruvbox
  {
    [1] = "LazyVim",
    optional = true,
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
}
