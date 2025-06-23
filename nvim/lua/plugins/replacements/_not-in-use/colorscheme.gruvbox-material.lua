---@type LazySpec[]
return {
  -- add gruvbox
  {
    [1] = "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    version = false, -- use the latest git commit
    init = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      -- vim.g.gruvbox_material_transparent_background = 0
      -- vim.g.gruvbox_material_statusline_style = "mix"
    end,
  },

  -- Configure LazyVim to load gruvbox
  {
    [1] = "LazyVim/LazyVim",
    optional = true,
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
}
