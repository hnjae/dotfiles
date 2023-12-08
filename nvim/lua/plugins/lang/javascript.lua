local M = {}

M.get_null_ls_sources = function(null_ls, null_ls_utils)
  local ret = {}

  local mapping = {
    deno = {
      -- null_ls.builtins.diagnostics.deno_lint,
      null_ls.builtins.formatting.deno_fmt.with({
        filetypes = { "javascript", "javascriptreact", },
      }),
    },
    -- xo = {
    --   null_ls.builtins.diagnostics.xo,
    -- },
    -- eslint_d = {
    --    null_ls.builtins.diagnostics.eslint_d,
    -- },
    -- tsc = {
    --   null_ls.builtins.diagnostics.tsc,
    -- },
  }

  for exe, sources in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      for _, source in pairs(sources) do
        table.insert(ret, source)
      end
    end
  end

  return ret
end

return M
