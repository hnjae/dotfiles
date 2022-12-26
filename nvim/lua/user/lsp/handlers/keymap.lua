local M = {}

local status_tscope, t_builtin= pcall(require, "telescope.builtin")
local status_wk, wk = pcall(require, "which-key")

if not status_wk then
  M.setup = function() end
  return M
end

local Nkeymap = {
  -- replace default gd
  -- 0, { severity = {min=vim.diagnostic.severity.WARN} }
  ["[w"] = { vim.diagnostic.goto_prev, "warning", mode = "n" },
  ["]w"] = { vim.diagnostic.goto_next, "warning", mode = "n" },
  ["[g"] = { '<cmd>lua vim.diagnostic.goto_prev({ severity = {min=vim.diagnostic.severity.ERROR} })<CR>', "error", mode = "n" },
  ["]g"] = { '<cmd>lua vim.diagnostic.goto_next({ severity = {min=vim.diagnostic.severity.ERROR} })<CR>', "error", mode = "n" },
  ["gd"] = { vim.lsp.buf.definition, 'lsp-definition' },
  ["gD"] = { vim.lsp.buf.declaration, 'lsp-declaration' },
  ["K"] = { vim.lsp.buf.hover, 'lsp-declaration' },
  ["=="] = { vim.lsp.buf.formatting, 'lsp-formatting' },
  --
  ["gli"] = { vim.lsp.buf.implementation, 'lsp-implementation' },
  ["glt"] = { vim.lsp.buf.type_definition, 'lsp-type-definition' },
  ["glr"] = { vim.lsp.buf.references, 'lsp-references' },
  ["gls"] = { vim.lsp.buf.signature_help, 'lsp-signature-help' },
  --
  [_LANG_PREFIX .. "l"] = { name = '+lsp' },
  [_LANG_PREFIX .. "ln"] = { vim.lsp.buf.rename, 'lsp-rename' },
  [_LANG_PREFIX .. "la"] = { vim.lsp.buf.code_action, 'lsp-code-action' },
  [_LANG_PREFIX .. "lw"] = { name = '+lsp-workspace' },
  [_LANG_PREFIX .. "lwa"] = { vim.lsp.buf.add_workspace_folder, 'lsp-add-workspace' },
  [_LANG_PREFIX .. "lwr"] = { vim.lsp.buf.remove_workspace_folder, 'lsp-remove-workspace' },
  [_LANG_PREFIX .. "lwl"] = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'lsp-list-workspace' },
  --
  ["Zl"] = {
    function()
      for _, buf_client in pairs(vim.lsp.buf_get_clients()) do
        buf_client.stop()
      end
    end,
    'stop-lsp'
  },
}
local Vkeymap = {
  ["=="] = { vim.lsp.buf.range_formatting, 'lsp-formatting' },
  [_LANG_PREFIX .. "la"] = { vim.lsp.buf.range_code_action, 'lsp-code-action' },
}
local Telescope_keymap = {
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

local register_keymap = function(client_name, keymap, opts)
  local has_lsp_settings, lsp_settings = pcall(require, 'user.lsp.settings.' .. client_name)

  if not has_lsp_settings or not lsp_settings.unavailable then
    wk.register(keymap, opts)
    return
  end

  for lhs, rhs_capsuled in pairs(keymap) do
    if not lsp_settings.unavailable[rhs_capsuled[1]] then
      wk.register(
        { [lhs] = rhs_capsuled, },
        opts
      )
    end
  end
end

local setup = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ghd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

  if vim.b[bufnr]._is_lsp_keymap then
    return
  end
  vim.b[bufnr]._is_lsp_keymap = true

  register_keymap(
    client.name,
    Nkeymap,
    { mode = "n", silent = true, noremap = true, buffer = bufnr }
  )
  register_keymap(
    client.name,
    Vkeymap,
    { mode = "v", silent = true, noremap = true, buffer = bufnr }
  )

  if status_tscope then
    wk.register(
      Telescope_keymap,
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

M.setup = setup

return M
