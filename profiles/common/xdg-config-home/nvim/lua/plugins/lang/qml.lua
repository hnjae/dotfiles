---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "qmljs" } },
  },
  {
    [1] = "nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        qmlls = {
          mason = false,
          enabled = vim.fn.executable("qmlls") == 1,
        },
      },
    },
  },
  {
    [1] = "conform.nvim",
    optional = true,
    opts = function(_, opts)
      if vim.fn.executable("qmlformat") ~= 1 then
        return
      end

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.qml = { "qmlformat" }
      opts.formatters_by_ft.qmljs = { "qmlformat" }
    end,
  },
}
