-- https://dotfyle.com/neovim/colorscheme/trending

local colorschemes = {
  codedark = "codedark",
  gruvbox = "gruvbox",
  gruvbox_material = "gruvbox-material",
  kanagawa = "kanagawa",
  rose_pine = "rose-pine",
  -- catppuccin = "catppuccin",
  -- cyberdream = "cyberdream",
  -- tokyonight = "tokyonight",
}

local COLORSCHEME = colorschemes.kanagawa
local color_terminal = (vim.fn.has("gui_running") == 1) or (os.getenv("TERM_PROGRAM") == nil)

---@type LazySpec[]
return {
  {
    [1] = "LazyVim",
    optional = true,
    opts = { colorscheme = COLORSCHEME },
  },
  {
    [1] = "ellisonleao/gruvbox.nvim",
    version = false, -- use the latest git commit
    opts = {
      -- contrast = "soft",
      -- transparent_mode = true,
      dim_inactive = false,
      underline = false,

      -- terminal_colors = os.getenv("BASE16_THEME") == nil or vim.g.neovide,
      terminal_colors = color_terminal,
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
    [1] = "tokyonight.nvim",
    optional = true,
    enabled = COLORSCHEME == "tokyonight",
    opts = {
      style = "night",
    },
  },
  {
    [1] = "catppuccin/nvim",
    main = "catppuccin",
    lazy = false,
    version = "*",
    opts = {
      flavour = "mocha",
    },
  },
  {
    [1] = "sainnhe/gruvbox-material",
    lazy = false,
    version = false, -- use the latest git commit
    enabled = COLORSCHEME == "gruvbox-material",
    init = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_ui_contrast = "high"
    end,
  },
  {
    [1] = "rose-pine/neovim",
    lazy = false,
    enabled = COLORSCHEME == "rose-pine",
    version = "*",
    main = "rose-pine",
    opts = {
      dark_variant = "main",
      enable = {
        terminal = color_terminal,
      },
      highlight_groups = {
        Visual = { bg = "highlight_med", inherit = false }, -- inherit 을 하면 배경색이랑 mix 되나? 좀 어두움.
      },
    },
  },
  {
    [1] = "rebelot/kanagawa.nvim",
    lazy = false,
    enabled = COLORSCHEME == "kanagawa",
    -- build = ":KanagawaCompile",
    --[[
      NOTE:

      - kanagawa-wave: default dark theme (puple bg)
      - kanagawa-dragon: dark theme
      - kanagawa-lotus: light theme
      ]]
    opts = {
      compile = false,
      theme = "wave",
      -- background = {
      --   dark = "wave",
      --   light = "lotus",
      -- },
    },
  },
  {
    [1] = "scottmckendry/cyberdream.nvim",
    lazy = false,
    enabled = COLORSCHEME == "cyberdream",
    version = "*",
    opts = {
      transparent = true,
    },
  },
  {
    [1] = "tomasiser/vim-code-dark",
    lazy = false,
    enabled = COLORSCHEME == "codedark",
    version = false, -- use the latest git commit
    specs = {
      {
        [1] = "lualine.nvim",
        optional = true,
        opts = function(_, opts)
          -- use vim-code-dark's lualine theme
          local theme = require("lualine.themes.codedark")
          theme.terminal = theme.terminal or theme.insert
          theme.command = theme.command or theme.insert

          opts.options.theme = theme
        end,
      },
    },
  },
}
