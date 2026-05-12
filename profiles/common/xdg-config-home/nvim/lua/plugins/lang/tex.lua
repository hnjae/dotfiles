---@type LazySpec[]
return {
  {
    [1] = "nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        texlab = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "texlab", "tex-fmt" } },
      },
    },
  },
  -- {
  --   [1] = "nvim-lint",
  --   optional = true,
  --   opts = function(_, opts)
  --     if vim.fn.executable("chktex") ~= 1 then
  --       return
  --     end
  --
  --     opts.linters_by_ft = opts.linters_by_ft or {}
  --     opts.linters_by_ft.tex = opts.linters_by_ft.tex or {}
  --     opts.linters_by_ft.plaintex = opts.linters_by_ft.plaintex or {}
  --
  --     table.insert(opts.linters_by_ft.tex, "chktex")
  --     table.insert(opts.linters_by_ft.plaintex, "chktex")
  --   end,
  -- },
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        tex = { "tex-fmt" },
        plaintex = { "tex-fmt" },
      },
    },
  },
}
