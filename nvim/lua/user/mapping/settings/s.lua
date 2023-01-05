local M = {}
local status_wk, wk = pcall(require, "which-key")

_LANG_PREFIX = "s"

M.setup = function()
  if not status_wk then
    return
  end

  -- disable s/S, use c/0C instead
  vim.cmd([[
    nmap s <Nop>
    xmap s <Nop>
    vmap s <Nop>
    omap s <Nop>
  ]])
  -- vim.api.nvim_del_keymap("n", "s")

  wk.register({
    [_LANG_PREFIX] = { name="+lang" }
  })

  -- wk.register({
  --   [_LANG_PREFIX] = {
  --     -- c = { name = "+execute" },
  --     -- d = { name = "+debug" },
  --     -- difine bottom
  --     -- r = { name = "+refactor" },
  --     -- h = { name = "+help" },
  --     -- g = { name = "+goto" },
  --     mode = 'n'
  --   },
  -- })

  -----------------------------------------------------------------------------
  -- lsp
  -----------------------------------------------------------------------------
  wk.register({
    name = "+lsp",
    ["n"] = {vim.lsp.buf.rename, "lsp-rename"},
    ["a"] = {vim.lsp.buf.code_action, "lsp-code-action"},
    ["w"] = { name = '+lsp-workspace' },
    ["wa"] = { vim.lsp.buf.add_workspace_folder, 'lsp-add-workspace' },
    ["wr"] = { vim.lsp.buf.remove_workspace_folder, 'lsp-remove-workspace' },
    ["wl"] = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'lsp-list-workspace' },
  }, {mode = "n", prefix = _LANG_PREFIX .. "l"})
  wk.register({
    name = "+lsp",
    ["a"] = {vim.lsp.buf.range_code_action, "lsp-code-action"},
  }, {mode = "v", prefix = _LANG_PREFIX .. "l"})

  -- TODO: xmap for code-action? <2022-12-28, Hyunjae Kim>

  -----------------------------------------------------------------------------
  -- Fuzzy features
  -----------------------------------------------------------------------------
  local status_tscope, t_builtin= pcall(require, "telescope.builtin")
  local telescope_keymap = {
    name = "+telescope-lsp",
    ["d"] = { t_builtin.diagnostics, "diagnostics" },
    ["r"] = { t_builtin.lsp_references, "references" },
    ["i"] = { t_builtin.lsp_implementations, "implementation" },
    ["k"] = { t_builtin.lsp_definitions, "definition" },
    ["t"] = { t_builtin.lsp_type_definitions, "type-definition" },
    ["s"] = { name = "+symbols" },
    ["sd"] = { t_builtin.lsp_document_symbols, "document-symbols" },
    ["sw"] = { t_builtin.lsp_workspace_symbols, "workspace-symbols" },
    ["sW"] = { t_builtin.lsp_workspace_symbols, "all-workspace-symbols" },
  }
  if status_tscope then
    wk.register(
      telescope_keymap,
      {
        mode = "n",
        silent = false,
        noremap = false,
        -- buffer = bufnr,
        prefix= _LANG_PREFIX .. "f"
      }
    )
  end
end

return M
