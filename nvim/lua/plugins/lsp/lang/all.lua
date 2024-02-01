local M = {}

M.setup_lspconfig = function(lspconfig, opts) end

M.get_null_ls_sources = function(null_ls, null_ls_utils)
  local ret = {
    -- null_ls.builtins.completion.luasnip,
    -- null_ls.builtins.completion.spell, -- completion scope 더럽힘. 쓰지말자.
    -- null_ls.builtins.completion.tags,
    -- null_ls.builtins.hover.printenv,
    -- null_ls.builtins.hover.dictionary,
  }

  local mapping = {
    -- TODO: microsoft windows path  <2024-01-02>
    codespell = {
      null_ls.builtins.diagnostics.codespell.with({
        args = { "-I", vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "-" },
      }),
    },
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
