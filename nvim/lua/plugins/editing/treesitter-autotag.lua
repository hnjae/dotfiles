---@type LazySpec
return {
  [1] = "windwp/nvim-ts-autotag",
  lazy = true,
  cond = require("utils").is_treesitter,
  event = { "VeryLazy" },
  dependencies = {
    {
      [1] = "nvim-treesitter/nvim-treesitter",
      optional = true,
    },
  },
  ft = {
    "astro",
    "glimmer",
    "handlebars",
    "html",
    "javascript",
    "javascriptreact",
    "jsx",
    "markdown",
    "php",
    "rescript",
    "svelte",
    "tsx",
    "typescript",
    "typescriptreact",
    "vue",
    "xml",
  },
  opts = {},
}
