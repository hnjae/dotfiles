---@type LazySpec[]
return {
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft.zsh = { "shellcheck", "beautysh" }
    end,
  },
  {
    [1] = "nvimtools/none-ls.nvim",
    optional = true,
    dependencies = {
      "gbprod/none-ls-shellcheck.nvim",
    },
    opts = function(_, opts)
      local null_ls = require("null-ls")

      local mapping = {
        zsh = { null_ls.builtins.diagnostics.zsh },
        shellcheck = {
          require("none-ls-shellcheck.diagnostics").with({
            filetypes = { "zsh" },
          }),
          require("none-ls-shellcheck.code_actions").with({
            filetypes = { "zsh" },
          }),
        },
      }

      for exe, sources in pairs(mapping) do
        if vim.fn.executable(exe) == 1 then
          vim.list_extend(opts.sources, sources)
        end
      end
    end,
  },
}
