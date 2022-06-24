local M = {}


local status_wk, wk = pcall(require, "which-key")
local status_tscope, t_builtin= pcall(require, "telescope.builtin")
local status_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local status_lsp_status, lsp_status = pcall(require, "lsp-status")
status_lsp_status = false
local status_lsp_signature, lsp_signature = pcall(require, "lsp_signature")


local capabilities = nil
capabilities = vim.lsp.protocol.make_client_capabilities()

if status_cmp then
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end
if status_lsp_status then
  capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)
end
M.capabilities = capabilities

_STOP_LSP = function()
  for _, client in pairs(vim.lsp.get_active_clients()) do
    client.stop()
  end
end



M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if status_lsp_status then
    lsp_status.on_attach(client)
  end

  if status_lsp_signature then
    lsp_signature.on_attach()
  end

  if not status_wk then
    return
  end
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ghd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

  local keymap = {
    -- replace default gd
    -- 0, { severity = {min=vim.diagnostic.severity.WARN} }
    ["[w"] = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', "warning", mode = "n" },
    ["]w"] = { '<cmd>lua vim.diagnostic.goto_next()<CR>', "warning", mode = "n" },
    ["[g"] = { '<cmd>lua vim.diagnostic.goto_prev({ severity = {min=vim.diagnostic.severity.ERROR} })<CR>', "error", mode = "n" },
    ["]g"] = { '<cmd>lua vim.diagnostic.goto_next({ severity = {min=vim.diagnostic.severity.ERROR} })<CR>', "error", mode = "n" },
    ["gd"] = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'lsp-definition' },
    ["gD"] = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'lsp-declaration' },
    ["K"] = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'lsp-declaration' },
    ["=="] = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'lsp-formatting' },
    --
    ["gli"] = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'lsp-implementation' },
    ["glt"] = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'lsp-type-definition' },
    ["glr"] = { '<cmd>lua vim.lsp.buf.references()<CR>', 'lsp-references' },
    ["gls"] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'lsp-signature-help' },
    --
    [_LANG_PREFIX .. "r"] = { name = '+refactor' },
    [_LANG_PREFIX .. "rn"] = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'lsp-rename' },
    [_LANG_PREFIX .. "c"] = { name = '+code' },
    [_LANG_PREFIX .. "ca"] = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'lsp-code-action' },
    --
    ["Zl"] = { '<cmd>lua _STOP_LSP()<CR>', 'stop-lsp' },
  }
  wk.register(keymap, { mode = "n", silent = true, noremap = true, buffer = bufnr })

  local vkeymap = {
    ["=="] = { '<cmd>lua vim.lsp.buf.range_formatting()<CR>', 'lsp-formatting' },
    [_LANG_PREFIX .. "ca"] = { '<cmd>lua vim.lsp.buf.range_code_action()<CR>', 'lsp-code-action' },
  }
  wk.register(vkeymap, { mode = "v", silent = true, noremap = true, buffer = bufnr })
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  --

  if status_tscope then
    local telescope_keymap = {
      name = "+telescope-lsp",
      ["r"] = { t_builtin.lsp_references, "references" },
      ["w"] = { t_builtin.diagnostics, "diagnostics" },
      ["i"] = { t_builtin.lsp_implementations, "implementation" },
      ["d"] = { t_builtin.lsp_definitions, "definition" },
      ["t"] = { t_builtin.lsp_type_definitions, "type-definition" },
      ["s"] = { name = "+symbols" },
      ["sd"] = { t_builtin.lsp_document_symbols, "document-symbols" },
      ["sw"] = { t_builtin.lsp_workspace_symbols, "workspace-symbols" },
      ["sW"] = { t_builtin.lsp_workspace_symbols, "all-workspace-symbols" },
    }

    wk.register(
      telescope_keymap,
      {
        mode = "n",
        silent = false,
        noremap = false,
        buffer = bufnr,
        prefix= _LANG_PREFIX .. "t"
      }
    )
  end

end

return M
