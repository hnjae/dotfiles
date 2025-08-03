-- https://dotfyle.com/neovim/colorscheme/trending

local colorschemes = {
  codedark = "codedark",
  gruvbox = "gruvbox",
  gruvbox_material = "gruvbox-material",
  kanagawa = "kanagawa",
  rose_pine = "rose-pine",
  --
  catppuccin = "catppuccin",
  cyberdream = "cyberdream",
  tokyonight = "tokyonight",
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
    enabled = COLORSCHEME == "gruvbox",
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
      style = "moon",
    },
  },
  {
    [1] = "catppuccin/nvim",
    main = "catppuccin",
    lazy = false,
    enabled = COLORSCHEME == "catppuccin",
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
    version = false, -- no versioning, 2025-08-01
    enabled = COLORSCHEME == "kanagawa",
    -- build = "<cmd>KanagawaCompile<cr>",
    --[[
      NOTE:

      - kanagawa-wave: default dark theme (puple bg)
      - kanagawa-dragon: dark theme
      - kanagawa-lotus: light theme
      ]]
    opts = {
      compile = false,
      background = {
        dark = "wave",
      },
      colors = {
        theme = {
          all = {
            ui = {
              -- Remove the background of `LineNr`, `{Sign,Fold}Column` and friends
              -- Snacks / Aerial / Noice 등에서 text 앞 여백 색상이 다른 문제 해결.
              bg_gutter = "none",
            },
          },
        },
      },
      terminalColors = color_terminal, -- define vim.g.terminal_color_{0,17}

      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Dark completion (popup) menu // More uniform colors for the popup menu.
          -- Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
          -- PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          -- PmenuSbar = { bg = theme.ui.bg_m1 },
          -- PmenuThumb = { bg = theme.ui.bg_p2 },

          -- HACK: <https://github.com/rebelot/kanagawa.nvim/pull/268> 가 머지되기 전까지 사용 <2025-08-01>
          -- SnacksDashboard
          SnacksDashboardHeader = { fg = theme.vcs.removed },
          SnacksDashboardFooter = { fg = theme.syn.comment },
          SnacksDashboardDesc = { fg = theme.syn.identifier },
          SnacksDashboardIcon = { fg = theme.ui.special },
          SnacksDashboardKey = { fg = theme.syn.special1 },
          SnacksDashboardSpecial = { fg = theme.syn.comment },
          SnacksDashboardDir = { fg = theme.syn.identifier },

          -- SnacksNotifier
          SnacksNotifierBorderError = { link = "DiagnosticError" },
          SnacksNotifierBorderWarn = { link = "DiagnosticWarn" },
          SnacksNotifierBorderInfo = { link = "DiagnosticInfo" },
          SnacksNotifierBorderDebug = { link = "Debug" },
          SnacksNotifierBorderTrace = { link = "Comment" },
          SnacksNotifierIconError = { link = "DiagnosticError" },
          SnacksNotifierIconWarn = { link = "DiagnosticWarn" },
          SnacksNotifierIconInfo = { link = "DiagnosticInfo" },
          SnacksNotifierIconDebug = { link = "Debug" },
          SnacksNotifierIconTrace = { link = "Comment" },
          SnacksNotifierTitleError = { link = "DiagnosticError" },
          SnacksNotifierTitleWarn = { link = "DiagnosticWarn" },
          SnacksNotifierTitleInfo = { link = "DiagnosticInfo" },
          SnacksNotifierTitleDebug = { link = "Debug" },
          SnacksNotifierTitleTrace = { link = "Comment" },
          SnacksNotifierError = { link = "DiagnosticError" },
          SnacksNotifierWarn = { link = "DiagnosticWarn" },
          SnacksNotifierInfo = { link = "DiagnosticInfo" },
          SnacksNotifierDebug = { link = "Debug" },
          SnacksNotifierTrace = { link = "Comment" },

          ["RenderMarkdownH1Bg"] = { fg = theme.ui.fg, bg = theme.diag.info, bold = true },
          ["RenderMarkdownH2Bg"] = { fg = theme.ui.fg, bg = theme.diff.text, bold = true },
          ["RenderMarkdownH3Bg"] = { fg = theme.ui.fg, bg = theme.diff.add, bold = true },
          ["RenderMarkdownH4Bg"] = { fg = theme.ui.fg, bg = "NONE", bold = true },
          ["RenderMarkdownH5Bg"] = { fg = theme.syn.comment, bg = "NONE", bold = true },
          ["RenderMarkdownH6Bg"] = { fg = theme.syn.comment, bg = "NONE", bold = false },
        }
      end,
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
