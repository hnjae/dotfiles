---@type LazySpec
return {
  [1] = "todo-comments.nvim",
  enabled = true,
  optional = true,
  opts = {
    -- follow <https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/comment/highlights.scm>
    keywords = {
      -- @comment.note (예외: PERF, TEST - 별도 구분)
      NOTE = {
        alt = { "XXX", "INFO", "DOCS" },
      },
      -- @comment.todo
      TODO = {
        alt = { "WIP" },
      },
      -- @comment.warning (예외: HACK - 별도 구분, FIX - todo-comments 에서는 error 로 분류 )
      WARN = {
        alt = { "WARNING", "WARN", "FIX" },
      },
      -- @comment.error
      FIX = {
        alt = { "FIXME", "BUG", "ERROR", "DEPRECATED" },
      },
    },
    highlight = {
      before = "",
      keyword = "fg",
      after = "",
    },
  },
}
