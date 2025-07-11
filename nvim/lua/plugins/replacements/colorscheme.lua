-- https://dotfyle.com/neovim/colorscheme/trending

local colorschemes = {
  codedark = "codedark",
  gruvbox_material = "gruvbox-material",
  kanagawa = "kanagawa",
  rose_pine = "rose-pine",
  -- catppuccin = "catppuccin",
  -- cyberdream = "cyberdream",
  -- tokyonight = "tokyonight",
}

local COLORSCHEME = colorschemes.rose_pine

---@type LazySpec[]
return {
  {
    [1] = "LazyVim",
    optional = true,
    opts = { colorscheme = COLORSCHEME },
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
      -- terminalColors = vim.fn.has("gui_running") == 1,
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
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
