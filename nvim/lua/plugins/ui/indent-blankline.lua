return {
  -- shows indent line
  [1] = "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  enabled = true,
  cond = not require("utils").is_console,
  event = { "VeryLazy" },
  main = "ibl",
  opts = {
    scope = {
      enabled = false,
      -- highlight = require('rainbow-delimiters.default').highlight
    },
  },
  -- config = function(_, opts)
  --   local hooks = require("ibl.hooks")
  --   require("ibl").setup(opts)
  --   hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  -- end,
}
