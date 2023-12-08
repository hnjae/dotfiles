local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  local mapping = {
    -- includes formatter (using nixpkgs-fmt)
    ["rnix-lsp"] = "rnix",

    -- no formatter
    ["nil"] = "nil_ls",
  }
  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_null_ls_sources = function(null_ls)
  local ret = {}

  local mapping = {
    statix = { --lints & suggestions
      null_ls.builtins.diagnostics.statix,
      -- null_ls.builtins.code_actions.statix,
    },
    deadnix = { -- scan dead code
      null_ls.builtins.diagnostics.deadnix,
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
