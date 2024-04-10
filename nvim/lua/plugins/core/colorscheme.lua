-- colorscheme
---@type table<string, integer>
local colorschemes = {
  vscode = 1,
  kanagawa = 2,
  github = 3,
  tokyonight = 4,
  ---
  adwaita = 11,
  ---
  rasmus = 31,
  neon = 32,
  gruvbox = 33,
}

local colorscheme = colorschemes[require("val.colorscheme")]
if colorscheme == nil then
  colorscheme = 1
end

-- local colorscheme = colorschemes.rasmus
-- local colorscheme = colorschemes.adwaita

---@type LazySpec[]
return {
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
      vim.o.background = "dark"
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
      vim.cmd("colorscheme github_dark_default")
    end,
  },
  {
    [1] = "rafamadriz/neon",
    lazy = false,
    priority = 999999999,
    cond = colorscheme == colorschemes.neon,
    config = function()
      vim.g.neon_style = "dark"
      vim.cmd([[colorscheme neon]])
    end,
  },
  {
    [1] = "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 999999999,
    cond = colorscheme == colorschemes.gruvbox,
    config = function()
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
  {
    [1] = "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 999999999,
    cond = colorscheme == colorschemes.kanagawa,
    opts = {
      compile = true,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      -- NOTE:
      --[[
      kanagawa-dragon: dark theme
      kanagawa-lotus: light theme
      kanagawa-wave: puple theme
      ]]
      vim.cmd([[colorscheme kanagawa-wave]])
    end,
  },
  {
    [1] = "folke/tokyonight.nvim",
    lazy = false,
    priority = 999999999,
    cond = colorscheme == colorschemes.tokyonight,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
