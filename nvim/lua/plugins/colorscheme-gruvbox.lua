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
    [1] = "ellisonleao/gruvbox.nvim",
    version = false, -- use the latest git commit
    opts = {
      transparent_mode = false,
      dim_inactive = true,
      underline = false,
      terminal_colors = os.getenv("BASE16_THEME") == nil,
      overrides = {
        -- NormalFloat = { bg = "none" },
        -- NormalFloat = { link = "NormalNc" },

        -- Managed by todo-comments.nvim:
        ["@comment.todo"] = { link = "@comment" },
        ["@comment.note"] = { link = "@comment" },
        ["@comment.warning"] = { link = "@comment" },
        ["@comment.error"] = { link = "@comment" },

        FzfLuaHeaderText = { link = "Title" },
        FzfLuaHeaderBind = { link = "@punctuation.special" }, -- FzfLua 가 colorscheme 에서 자동으로 생성하지 않음.
        FzfLuaPath = { link = "Directory" },
        FzfLuaCursor = { link = "IncSearch" },
        FzfLuaFzfCursorLine = { link = "Visual" },

        -- from telescope
        -- FzfLuaNormal = { link = "TelescopeNormal" },
        FzfLuaBorder = { link = "TelescopeBorder" },
        FzfLuaTitle = { link = "TelescopePromptTitle" },
        FzfLuaFzfSeparator = { link = "TelescopePromptBorder" },
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
