--[[
]]

---@type LazySpec[]
return {
  -- add gruvbox
  {
    [1] = "sainnhe/gruvbox-material",
    lazy = false,
    version = false, -- use the latest git commit
    init = function()
      -- vim.g.gruvbox_material_background = "soft"
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
