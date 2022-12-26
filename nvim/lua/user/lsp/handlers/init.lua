-- [[
-- returns:
--  .on_attach, .capabilities for lspconfig to use
-- ]]

local M = {}

local status_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local status_lsp_status, lsp_status = pcall(require, "lsp-status")
local status_lsp_signature, lsp_signature = pcall(require, "lsp_signature")


-------------------------------------------------------------------------------
-- capabilities
-------------------------------------------------------------------------------

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- 기본이 true 인것 같지만, 선언해 둔다.
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- global_capabilities.textDocument.completion.completionItem.resolveSupport = {
-- 	properties = {
-- 		"documentation",
-- 		"detail",
-- 		"additionalTextEdits",
-- 	},
-- }


if status_cmp then
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

if status_lsp_status then
  capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)
end

M.capabilities = capabilities

-------------------------------------------------------------------------------
-- on_attach
-------------------------------------------------------------------------------

M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if status_lsp_status then
    lsp_status.on_attach(client)
  end

  if status_lsp_signature then
    lsp_signature.on_attach()
  end

  require("user.lsp.handlers.commands").setup(client, bufnr)
  require("user.lsp.handlers.keymap").setup(client, bufnr)
end

-- M.on_init = function(client)
--   local path = client.workspace_folders[1].name

--   if path == '/path/to/project1' then
--     client.config.settings.xxx = "yyyy"
--   elseif path == '/path/to/project2' then
--     client.config.settings.xxx = "zzzz"
--   end

--   client.notify("workspace/didChangeConfiguration")
--   return true
-- end

return M
