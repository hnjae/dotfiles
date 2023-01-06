-- lsp
-- local use_native_lsp = true

local mason_lspconfig_spec = {
  'williamboman/mason-lspconfig.nvim',
  lazy = false,
  priority = 1,
  dependenceis = {
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
  },
  -- event = "VimEnter",
}
mason_lspconfig_spec.config = function()
  require("mason").setup()
  require("mason-lspconfig").setup()

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

  local status_lsp_status, lsp_status = pcall(require, "lsp-status")
  local status_lsp_signature, lsp_signature = pcall(require, "lsp_signature")
  local status_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

  -------------------------------------
  -- on_attach
  -------------------------------------
  local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    if status_lsp_status then
      lsp_status.on_attach(client)
    end

    if status_lsp_signature then
      lsp_signature.on_attach()
    end
  end

  -------------------------------------
  -- capabilities
  -------------------------------------
  local global_capabilities = vim.lsp.protocol.make_client_capabilities()
  global_capabilities.textDocument.completion.completionItem.snippetSupport = true
  if status_cmp_nvim_lsp then
    -- capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    global_capabilities = vim.tbl_extend(
      'keep', global_capabilities or {}, cmp_nvim_lsp.default_capabilities()
    )
  end
  if status_lsp_status then
    global_capabilities = vim.tbl_extend(
      'keep', global_capabilities or {}, lsp_status.capabilities
    )
  end

  -------------------------------------
  --
  -------------------------------------
  local lspconfig = require("lspconfig")
  lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    capabilities = global_capabilities,
  })

  -- setup each server
  for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
    lspconfig[server].setup({
      on_attach = on_attach
    })
  end
end

return {
  -----------------------------------------------------------------------------
  -- native lsp
  -----------------------------------------------------------------------------
  {
    'tamago324/nlsp-settings.nvim',
    lazy = true,
    dependenceis = {
      'neovim/nvim-lspconfig',
      -- 'williamboman/nvim-lsp-installer', -- recommends
      'rcarriga/nvim-notify', -- optional
    },
    module = true,
  },
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    module = true,
  },
  {
    -- lsp/formatter/... installer
    'williamboman/mason.nvim',
    lazy = true,
    module = true,
  },
  {
    'folke/neodev.nvim',
    lazy=true,
    enabled=false,
    module=true,
  },
  mason_lspconfig_spec

  -- {
  --   'williamboman/nvim-lsp-installer',
  --   lazy = true,
  --   dependenceis = { 'neovim/nvim-lspconfig' },
  -- },
}
