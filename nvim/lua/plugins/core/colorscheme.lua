-- TODO: terminal 색상 읽어서, 맞춰서 변경하기 <2024-06-11>
-- vim.opt.background = "dark"

-- colorscheme
---@type table<string, integer>
local colorschemes = {
  ansi = -1,
  ---
  vscode = 1,
  kanagawa = 2,
  github = 3,
  tokyonight = 4,
  ---
  adwaita = 11,
  ---
  gruvbox = 33,
  -- rasmus = 31,
  -- neon = 32,
  --
}

local colorscheme = colorschemes[require("val.colorscheme")]
if colorscheme == nil then
  colorscheme = -1
end

---@type LazySpec[]
return {
  {
    dir = vim.fn.getenv("HOME") .. "/Projects/ansi.nvim",
    priority = 999999999,
    cond = colorscheme == colorschemes.ansi,
    name = "ansi",
    lazy = false,
    opts = {},
  },
  {
    [1] = "jsit/disco.vim",
    lazy = false,
    cond = colorscheme == colorschemes.disco,
    priority = 999999999,
    opts = {},
    init = function() end,
    config = function()
      vim.cmd([[colorscheme disco]])
    end,
  },
  {
    [1] = "Mofiqul/vscode.nvim",
    -- NOTE: does not support htmlH1 (2022-06-21)
    lazy = false,
    cond = colorscheme == colorschemes.vscode,
    priority = 999999999,
    opts = {
      italic_comments = true,
    },
    init = function()
      if vim.opt.background:get() == nil then
        vim.opt.background = "dark"
      end
      vim.g.vscode_style = vim.o.background
    end,
    config = function()
      vim.cmd([[colorscheme vscode]])
    end,
  },
  {
    [1] = "kvrohit/rasmus.nvim",
    lazy = false,
    cond = colorscheme == colorschemes.rasmus,
    priority = 999999999,
    init = function()
      -- vim.g.rasmus_italic_functions = false
      -- vim.g.rasmus_bold_functions = true
    end,
    config = function()
      vim.cmd([[colorscheme rasmus]])
    end,
  },
  {
    [1] = "Mofiqul/adwaita.nvim",
    lazy = false,
    cond = colorscheme == colorschemes.adwaita,
    priority = 999999999,
    config = function()
      vim.g.adwaita_darker = false -- for darker version
      vim.g.adwaita_disable_cursorline = true -- to disable cursorline
      vim.cmd([[colorscheme adwaita]])
    end,
  },
  {
    [1] = "projekt0n/github-nvim-theme",
    lazy = false,
    cond = colorscheme == colorschemes.github,
    priority = 999999999,
    main = "github-theme",
    opts = {
      options = {
        dim_inactive = true,
        -- terminal_colors = true,
        darken = {
          sidebars = {
            enabled = true,
            list = {
              "tagbar",
              "Outline",
              "sagaoutline",
              "NvimTree",
              "neo-tree",
              "OverseerList",
              "Trouble",
              "toggleterm",
              "qf",
            },
          },
        },
      },
    },
    config = function(plugin, opts)
      --[[
      NOTE:
      github_dark
      github_dark_default
      github_dark_dimmed
      ]]
      require(plugin.main).setup(opts)
      if vim.opt.background:get() == "light" then
        vim.cmd("colorscheme github_light_default")
      else
        vim.cmd("colorscheme github_dark")
      end
    end,
  },
  {
    [1] = "rafamadriz/neon",
    lazy = false,
    priority = 999999999,
    cond = colorscheme == colorschemes.neon,
    config = function()
      if vim.opt.background:get() == "light" then
      else
        vim.g.neon_style = "dark"
      end
      vim.cmd([[colorscheme neon]])
    end,
  },
  {
    [1] = "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 999999999,
    cond = colorscheme == colorschemes.gruvbox,
    opts = {
      -- dim_inactive = true,
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      --[[
       NOTE: <2024-05-16>
       gruvbox.nvim 는 vim.opt.background 값에 맞춰서 알아서 설정됨.
      ]]
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
  {
    [1] = "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 999999999,
    cond = colorscheme == colorschemes.kanagawa,
    -- build = ":KanagawaCompile",
    opts = {
      compile = false,
      terminalColors = false,
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },

          -- TelescopeTitle = { fg = theme.ui.special, bold = true },
          -- TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          -- TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          -- TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          -- TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          -- TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          -- TelescopePreviewBorder = {
          --   bg = theme.ui.bg_dim,
          --   fg = theme.ui.bg_dim,
          -- },
        }
      end,
      theme = "wave",
      background = {
        dark = "dragon",
        light = "lotus",
      },
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      -- NOTE:
      --[[
      kanagawa-dragon: dark theme
      kanagawa-lotus: light theme
      kanagawa-wave: puple theme and colors are more bright
      ]]
      vim.cmd([[colorscheme kanagawa]])
    end,
  },
  {
    [1] = "folke/tokyonight.nvim",
    lazy = false,
    priority = 999999999,
    cond = colorscheme == colorschemes.tokyonight,
    config = function()
      if vim.opt.background:get() == "light" then
        vim.cmd([[colorscheme tokyonight-day]])
      else
        vim.cmd([[colorscheme tokyonight-night]])
      end
    end,
  },
}
