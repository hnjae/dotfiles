-- Use treesitter to auto close and auto rename html tag

return {
  [1] = "nvim-treesitter/nvim-treesitter",
  optional = true,
  specs = {
    {
      [1] = "windwp/nvim-ts-autotag",
      lazy = true,
      event = { "VeryLazy" },
      dependencies = {
        { [1] = "nvim-treesitter/nvim-treesitter" },
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
    },
  },
}
