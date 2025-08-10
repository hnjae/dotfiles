-- TODO: stylua 가 가끔 indent-type 을 tabs 로 지정해버리는데 이유가 뭔지 해결 <2025-06-08>
---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      lua = {
        "stylua",
        -- lsp_format = "never"
      },
    },
  },
}
