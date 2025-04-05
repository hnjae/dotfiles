---@type LazySpec[]
return {
  {
    [1] = "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require("null-ls")

      local mapping = {
        ["editorconfig-checker"] = {
          null_ls.builtins.diagnostics.editorconfig_checker.with({
            filetypes = { "editorconfig" },
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
