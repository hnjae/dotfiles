--[[
  NOTE:
    overriding `lang.markdown` from LazyExtra
--]]
---@type LazySpec
return {
  [1] = "render-markdown.nvim",
  optional = true,
  enabled = false,
  opts = {
    html = {
      comment = {
        conceal = false,
      },
    },
    win_options = {
      conceallevel = {
        default = vim.o.conceallevel,
        rendered = 2,
      },
    },
  },
}
