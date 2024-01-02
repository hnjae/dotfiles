local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    -- provides grammar and spelling errors in markup documents (LaTeX, Markdown, etc.). The documents are checked with LanguageTool.
    ["ltex-ls"] = "ltex",
  }

  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_null_ls_sources = function(null_ls, null_ls_utils)
  local ret = {
    -- null_ls.builtins.completion.luasnip,
    -- null_ls.builtins.completion.spell, -- completion scope 더럽힘. 쓰지말자.
    -- null_ls.builtins.completion.tags,
    null_ls.builtins.hover.printenv,
    null_ls.builtins.hover.dictionary,
  }

  local mapping = {
    codespell = {
      null_ls.builtins.diagnostics.codespell.with({
        -- TODO: microsoft windows path  <2024-01-02>
        args = { "-I", vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "-" },
      }),
    },
    -- english prose linter
    proselint = {
      null_ls.builtins.diagnostics.proselint,
    },
    -- english prose linter
    wirte_good = {
      null_ls.builtins.diagnostics.write_good,
    },
    -- misspell = {
    --   null_ls.builtins.diagnostics.misspell,
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
