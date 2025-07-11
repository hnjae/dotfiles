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
      -- contrast = "soft",
      -- transparent_mode = true,
      dim_inactive = false,
      underline = false,

      -- terminal_colors = os.getenv("BASE16_THEME") == nil or vim.g.neovide,
      terminal_colors = vim.fn.has("gui_running") == 1,
      -- terminal_colors = true,
      palette_overrides = {
        light1 = "#F0E2B8", -- HSL: 45, 64.6, 83.2
      },
      overrides = {
        -- NormalFloat = vim.opt.background:get() == "light" and { bg = "#f2e5bc" }, -- light0_soft
        -- NormalNc = vim.opt.background:get() == "light" and { bg = "#f2e5bc" } or { link = "Normal" }, -- light0_soft
        NormalFloat = { link = "Normal" },
        NonText = { link = "GruvBoxBg4" }, -- default: GruvBoxBg2

        -- ["RenderMarkdownH1Bg"] = { link = "ErrorMsg" },
        -- ["RenderMarkdownH1Bg"] = { link = "PmenuSel" },
        ["RenderMarkdownH1Bg"] = { link = "DiffAdd" },
        ["RenderMarkdownH2Bg"] = { link = "DiffChange" },
        ["RenderMarkdownH3Bg"] = { link = "CursorLine" },
        ["RenderMarkdownH4Bg"] = { link = "markdownBold" },
        -- ["RenderMarkdownH5Bg"] = { link = "markdownH5" },
        ["RenderMarkdownH5Bg"] = { link = "markdownBold" },
        ["RenderMarkdownH6Bg"] = { link = "markdownBold" },

        -- Managed by todo-comments.nvim:
        ["@comment.todo"] = { link = "@comment" },
        ["@comment.note"] = { link = "@comment" },
        ["@comment.warning"] = { link = "@comment" },
        ["@comment.error"] = { link = "@comment" },

        FzfLuaNormal = { link = "Normal" },
        FzfLuaBorder = { link = "TelescopeBorder" },
        FzfLuaTitle = { link = "TelescopePromptTitle" },
        FzfLuaFzfSeparator = { link = "TelescopePromptBorder" },

        FzfLuaHeaderBind = { link = "@punctuation.special" }, -- FzfLua 가 colorscheme 에서 자동으로 생성하지 않음. (BlanchedAlmond)
        FzfLuaLivePrompt = { link = "GruvboxPurple" }, -- FzfLua 가 colorscheme 에서 자동으로 생성하지 않음. (PaleVioletRed1)

        FzfLuaBackdrop = { link = "GruvBoxBg0" }, -- bg=Black
        FzfLuaHeaderText = { link = "Title" }, -- Brown1
        FzfLuaPathColNr = { link = "GruvBoxAqua" }, -- CadgetBlue1
        FzfLuaPathLineNr = { link = "GruvBoxGreen" }, -- light green
        FzfLuaBufNr = { link = "FzfLuaHeaderBind" }, -- BlanchedAlmond
        FzfLuaBufFlagCur = { link = "FzfLuaHeaderText" }, -- Brown1
        FzfLuaBufFlagAlt = { link = "FzfLuaPathColNr" }, -- CadgetBlue1
        FzfLuaTabTitle = { link = "GruvBoxBlue" }, -- LightSkyBlue1
        FzfLuaTabMarker = { link = "FzfLuaHeaderBind" }, -- BlanchedAlmond
      },
    },
  },

  {
    [1] = "ibhagwan/fzf-lua",
    optional = true,
    opts = {
      fzf_colors = {
        true,
      },
    },
  },

  -- Configure LazyVim to load gruvbox
  {
    [1] = "LazyVim",
    optional = true,
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
