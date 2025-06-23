---@type LazySpec[]
return {
  -- {
  --   [1] = "jan-warchol/selenized",
  --   version = false, -- use the latest git commit
  --   opts = {},
  -- },

  -- Configure LazyVim to load gruvbox
  {
    [1] = "LazyVim",
    optional = true,
    opts = {
      colorscheme = "selenized",
    },
  },
}
