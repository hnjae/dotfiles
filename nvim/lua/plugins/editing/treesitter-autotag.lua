---@type LazySpec
return {
  [1] = "windwp/nvim-ts-autotag",
  lazy = true,
  enabled = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
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
