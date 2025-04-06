---@type LazySpec
return {
  [1] = "nvim-lualine/lualine.nvim",
  optional = true,
  opts = function(_, opts)
    -- disable clock time
    opts.sections.lualine_z = {}
  end,
}
