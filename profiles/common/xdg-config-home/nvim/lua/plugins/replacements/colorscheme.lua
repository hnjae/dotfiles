-- https://dotfyle.com/neovim/colorscheme/trending
-- local color_terminal = (vim.fn.has("gui_running") == 1) or (os.getenv("TERM_PROGRAM") == nil)

---@type LazySpec
return {
  [1] = "sainnhe/gruvbox-material",
  version = false, -- use the latest git commit
  lazy = false,
  priority = 1000,
  cond = vim.o.termguicolors,
  init = function()
    vim.g.gruvbox_material_cursor = "auto"
    vim.g.gruvbox_material_disable_terminal_colors = 1

    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_enable_bold = 1

    -- Contrast
    vim.g.gruvbox_material_foreground = "original"
    vim.g.gruvbox_material_ui_contrast = "high"
    vim.g.gruvbox_material_inlay_hints_background = "dimmed"

    --[[
    NOTE:
      `better_performance` generates `after/syntax` files at startup.
      If `~/.config/nvim` is read-only, t will fail to first render when the theme tries to write there.
    --]]
    vim.g.gruvbox_material_better_performance = 0
  end,
  specs = {
    {
      [1] = "LazyVim",
      optional = true,
      opts = { colorscheme = "gruvbox-material" },
    },
    {
      [1] = "tokyonight.nvim",
      enabled = false,
      optional = true,
    },
    {
      [1] = "lualine.nvim",
      optional = true,
      opts = {
        theme = "gruvbox-material",
      },
    },
  },
}
