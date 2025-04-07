---@type LazySpec[]
return {
  {
    [1] = "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 999999999,
    -- build = ":KanagawaCompile",
    opts = {
      compile = false,
      -- terminalColors = vim.fn.has("gui_running") == 1,
      terminalColors = true,
      overrides = function(colors)
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
      -- vim.cmd([[colorscheme kanagawa]])
    end,
  },
  {
    [1] = "LazyVim/LazyVim",
    optional = true,
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
