vim.api.nvim_set_option_value("background", "light", {})

---@type LazySpec
return {
  [1] = "f-person/auto-dark-mode.nvim",
  version = false, -- no versioning, 2026-03-08
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  fallback = "light",
}
