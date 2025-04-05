-- https://github.com/nvim-neorg/neorg/wiki/Tutorial

---@type LazySpec
return {
  [1] = "nvim-neorg/neorg",
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  config = true,
  enabled = vim.fn.has("nvim-0.10") == 1 and vim.fn.executable("luarocks") == 1,
  opts = {
    require("plugins.core.treesitter.languages"):add("norg"),
  },
  specs = {},
}
