---@type LazySpec
return {
  [1] = "sevenc-nanashi/neov-ime.nvim",
  lazy = false,
  enabled = vim.fn.has("nvim-0.12") ~= 0,
}
