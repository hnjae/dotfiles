---@type LazySpec
return {
  [1] = "olimorris/codecompanion.nvim",
  version = "*",

  lazy = true,
  event = "VeryLazy", -- maybe something else
  opts = {},
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-lua/plenary.nvim" },
    {
      [1] = "nvim-cmp",
      optional = true,
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        table.insert(opts.sources, {
          name = "codecompanion",
        })

        return opts
      end,
    },
  },
}
