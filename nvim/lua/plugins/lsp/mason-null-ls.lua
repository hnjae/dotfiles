---@type LazySpec
return {
  [1] = "jay-babu/mason-null-ls.nvim",
  lazy = true,
  event = { "BufRead", "BufNewFile" },
  enabled = vim.fn.has("unix") ~= 1,
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    ensure_installed = {
      "ktlint",
      "black",
      "mypy",
      "selene",
      "stylua",
      "shfmt",
      "shellcheck",
    },
  },
}
