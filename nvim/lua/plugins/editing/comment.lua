-- NOTE: support dot-repeat

-- :h comment-nvim

-- NOTE: which-key.nvim complains key conflict:
-- https://github.com/folke/which-key.nvim/issues/218#issuecomment-1890858022
-- https://github.com/numToStr/Comment.nvim/issues/167

local is_treesitter = require("utils").is_treesitter

---@type LazySpec
return {
  [1] = "numToStr/Comment.nvim",
  lazy = false,
  event = { "VeryLazy" },
  enabled = true,
  dependencies = {
    {
      [1] = "JoosepAlviste/nvim-ts-context-commentstring",
      lazy = true,
      enabled = is_treesitter,
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
    local ret = {
      -- opleader = { line = "gc", block = "gb" },
      mappings = { basic = true, extra = true },
    }

    if is_treesitter then
      ret.pre_hook = require(
        "ts_context_commentstring.integrations.comment_nvim"
      ).create_pre_hook()
    end

    return ret
  end,
  specs = {
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      -- deprecated in which-key v3
      -- opts = {
      --   operators = {
      --     gc = "comment-line",
      --     gb = "comment-block",
      --   },
      -- },
    },
  },
}
