---@type LazySpec[]
return {
  {
    [1] = "todo-comments.nvim",
    enabled = true,
    optional = true,
    opts_extend = { "keywords.FIX.alt", "keywords.WARN.alt" },
    opts = {
      keywords = {
        WARN = {
          alt = { "WIP" },
        },
      },
      highlight = {
        before = "",
        keyword = "fg",
        after = "",
      },
    },
  },
}
