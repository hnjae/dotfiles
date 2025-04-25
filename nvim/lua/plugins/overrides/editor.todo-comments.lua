local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "todo-comments.nvim",
  optional = true,
  keys = {
    -- restore the default vim mappings by resetting any overrides.
    { "[t", false },
    { "]t", false },
    -- { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    -- { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
  },
  opts = {
    -- follow <https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/comment/highlights.scm>
    keywords = {
      -- @comment.note (예외: PERF, TEST - 별도 구분)
      NOTE = {
        icon = icons.severity.hint,
        alt = { "XXX", "INFO", "DOCS" },
      },
      -- @comment.todo
      TODO = {
        icon = "󰗡 ", -- nf-md
        alt = { "WIP" },
      },
      -- @comment.warning (예외: HACK - 별도 구분, FIX - todo-comments 에서는 error 로 분류 )
      WARN = {
        icon = icons.severity.warn,
        alt = { "WARNING", "WARN", "FIX" },
      },
      -- @comment.error
      FIX = {
        icon = "󰃤 ", --nf-md
        alt = { "FIXME", "BUG", "ERROR", "DEPRECATED" },
      },
      HACK = {
        icon = "󰶯 ", -- nf-md
      },
      TEST = {
        icon = "󰂕 ", --nf-md
      },
      PERF = {
        icon = "󰅐 ", -- nf-md
      },
    },
    highlight = {
      before = "",
      keyword = "fg",
      after = "",
    },
  },
}
