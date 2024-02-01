-- NOTE: support dot-repeat

---@type LazySpec
return {
  [1] = "numToStr/Comment.nvim",
  lazy = true,
  event = { "VeryLazy" },
  enabled = true,
  dependencies = {
    {
      [1] = "JoosepAlviste/nvim-ts-context-commentstring",
      lazy = false,
      event = { "VeryLazy" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {},
      init = function()
        vim.g.skip_ts_context_commentstring_module = true
      end,
    },
  },
  opts = function()
    return {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }
  end,
}
