local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    ["typescript-language-server"] = "tsserver",
  }

  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_null_ls_sources = function(null_ls, null_ls_utils)
  local ret = {}

  local mapping = {
    deno = {
      -- null_ls.builtins.diagnostics.deno_lint.with({
      --   filetypes = { "typescript", "typescriptreact" },
      -- }),
      -- null_ls.builtins.formatting.deno_fmt.with({
      --   filetypes = { "typescript", "typescriptreact" },
      -- }),
    },
    -- prettier as daemon
    prettierd = {
      null_ls.builtins.formatting.prettierd.with({
        -- filetypes = { "typescript", "typescriptreact" },
      }),
    },
    eslint = {
      null_ls.builtins.code_actions.eslint.with({
        -- filetypes = { "typescript", "typescriptreact" },
      }),
      null_ls.builtins.diagnostics.eslint.with({
        -- filetypes = { "typescript", "typescriptreact" },
      }),
      -- null_ls.builtins.formatting.eslint.with({
      --   filetypes = { "typescript", "typescriptreact" },
      -- }),

    },
    -- eslint wrapper
    -- xo = {
    --   null_ls.builtins.diagnostics.xo.with({
    --     filetypes = { "typescript", "typescriptreact" },
    --   }),
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
