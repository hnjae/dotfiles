-- TODO: hello <2025-04-07>
-- FIXME: foo <2025-04-07>
-- WARNING: ifoo <2025-04-07>
-- NOTE:  <2025-04-07>
-- TEST: <foo>

---@type LazySpec[]
return {
  {
    [1] = "folke/todo-comments.nvim",
    enabled = true,
    optional = true,
    opts = {
      highlight = {
        before = "",
        keyword = "fg",
        after = "",
      },
    },
  },
}
