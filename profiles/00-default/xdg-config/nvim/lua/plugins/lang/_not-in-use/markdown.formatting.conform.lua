---@type LazySpec[]
return {
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        markdown = { lsp_format = "prefer" },
      },
    },
  },
}
