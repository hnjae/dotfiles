local M = {}

M.setup = function()

  local status_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
  local status_lspconfig, lspconfig = pcall(require, "lspconfig")
  if not status_lspconfig or not status_lsp_installer then
    return
  end

  local status_nlspsettings, nlspsettings = pcall(require, "nlspsettings")
  if status_nlspsettings then
    nlspsettings.setup({
      config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
      local_settings_dir = ".nlsp-settings",
      local_settings_root_markers_fallback = { '.git' },
      append_default_schemas = true,
      loader = 'yaml'
    })
  end

  local status_neodev, neodev = pcall(require, "neodev")
  if status_neodev then
    neodev.setup()
  end

  local on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  end

  local global_capabilities = vim.lsp.protocol.make_client_capabilities()
  global_capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- TODO: attach lsp_signature per buffer here <2022-12-27, Hyunjae Kim>
  lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    capabilities = global_capabilities,
  })

  lsp_installer.on_server_ready(function(server)
    server:setup({
      on_attach = on_attach
    })
  end)


end

return M
