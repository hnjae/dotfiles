---@type LazySpec
return {
  -- shows marks
  [1] = "chentoast/marks.nvim",
  lazy = true,
  enabled = true,
  event = { "VeryLazy" },
  opts = {
    default_mappings = false,
    refresh_interval = 200, -- default 150
  },
}
