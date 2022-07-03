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
  ["[w"] = { "<plug>(coc-diagnostic-prev)", "warning", mode = "n" },
  ["]w"] = { "<plug>(coc-diagnostic-next)", "warning", mode = "n" },
  ["[g"] = { "<plug>(coc-diagnostic-prev-error)", "error", mode = "n" },
  ["]g"] = { "<plug>(coc-diagnostic-next-error)", "error", mode = "n" },
  ["gd"] = { "<Plug>(coc-definition)", 'coc-definition' },
  ["gD"] = { vim.lsp.buf.declaration, 'lsp-declaration' },
  -- ["K"] = { "<cmd>call ShowDocumentation()<CR>", 'coc-show-doc' },
  ["=="] = { vim.lsp.buf.formatting, 'lsp-formatting' },
  --
  ["gli"] = { "<Plug>(coc-implementation)", 'coc-implementation' },
  ["glt"] = { vim.lsp.buf.type_definition, 'lsp-type-definition' },
  ["glr"] = { "<Plug>(coc-references)", 'coc-references' },
  ["gls"] = { vim.lsp.buf.signature_help, 'lsp-signature-help' },
  --
  [_LANG_PREFIX .. "l"] = { name = '+lsp' },
  [_LANG_PREFIX .. "ln"] = { vim.lsp.buf.rename, 'lsp-rename' },
  [_LANG_PREFIX .. "la"] = { vim.lsp.buf.code_action, 'lsp-code-action' },
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
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  --

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
