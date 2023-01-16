-- lsp
-- local use_native_lsp = true

-- local on_fts = {
--   'python', 'lua', 'sh',
-- }

local mason_spec = {
  'williamboman/mason.nvim',
  lazy = false,
  -- ft = on_fts,
  event = { 'InsertEnter' },
  dependencies = {
    'hrsh7th/nvim-cmp',
    { 'neovim/nvim-lspconfig' },
    {
      'tamago324/nlsp-settings.nvim',
      dependencies = { 'neovim/nvim-lspconfig', 'rcarriga/nvim-notify' }
    },
    {
      'williamboman/mason-lspconfig.nvim',
      dependencies = { 'neovim/nvim-lspconfig' },
    },
    {
      -- shows popup window about parameter/func
      -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
      'ray-x/lsp_signature.nvim',
      -- config = function() require('lsp_signature').setup() end,
    },
    { 'folke/neodev.nvim', },
  }

}

mason_spec.config = function()
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

  local status_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

  -------------------------------------
  -- on_attach
  -------------------------------------
  local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    require("lsp_signature").on_attach()
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
  mason_spec,
  {
    -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
    'folke/trouble.nvim',
    lazy = true,
    -- event = {},
    enabled = true,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'williamboman/mason.nvim',
    },
  },
  {
    -- TODO: chick this out! <2023-01-08, Hyunjae Kim>
    'jose-elias-alvarez/null-ls.nvim',
    lazy = true,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'williamboman/mason.nvim',
    },
  },


  -- https://github.com/sbdchd/neoformat
  -- https://github.com/mhartington/formatter.nvim
  -- https://github.com/folke/lsp-colors.nvim

  ------------------------------------------------------------------------------
  -- dap
  ------------------------------------------------------------------------------
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
      'folke/which-key.nvim'
    },
    config = function()
      local dap_prefix = "_LANG_PREFIX" .. "d"
      local dap = require("dap")
      local wk = require("which-key")

      local mapping = {
        name = "+dap",
        c = { dap.continue, "continue" },
        s = { name = "+step" },
        sv = { dap.step_over, "step-over" },
        si = { dap.step_into, "step-into" },
        so = { dap.step_into, "step-out" },
        b = { dap.toggle_breakpoint, "toggle-breakpoint" },
        -- B = { dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')), "set-breakpoint-cond" },
        -- v = { dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')), "set-breakpoint-log" },
        r = { dap.repl.open, "repl-open" },
        l = { dap.run_last, "run-last" },
      }
      wk.register(
        mapping,
        { noremap = false, mode = "n", prefix = _MAPPING_PREFIX["lang"] .. "d" }
      )
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    lazy = true,
    config = function()
      require("dapui").setup()
    end
  },


  {
    'puremourning/vimspector',
    lazy = true,
    enabled = false,
    cond = vim.fn.has('python3'),
    dependencies = {
      'folke/which-key.nvim'
    },
    config = function()
      vim.g.vimspector_install_gadgets = {
        "depugby"
      }
      local has_wk, wk = pcall(require, "which-key")

      if has_wk then
        local mapping = {
          ["name"] = "+vimspector",
          c = { "<Plug>VimspectorContinue", "continue" },
          s = { "<Plug>VimspectorStop", "stop" },
          R = { "<Plug>VimspectorRestart", "restart" },
          p = { "<Plug>VimspectorPause", "pause" },
          --
          b = { "<Plug>VimspectorToggleBreakpoint", "toggle-line-breakpoint" },
          B = { "<Plug>VimspectorToggleConditionalBreakpoint", "toggle-conditional-line-breakpoint" },
          f = { "<Plug>VimspectorAddFunctionBreakpoint", "add-function-breakpoint" },
          --
          v = { "<Plug>VimspectorStepOver", "step-over" },
          i = { "<Plug>VimspectorStepInto", "step-into" },
          o = { "<Plug>VimspectorStepOut", "step-out" },
          --
          r = { "<Plug>VimspectorRunToCursor", "run-to-cursor" },
        }
        wk.register(mapping, { prefix = _MAPPING_PREFIX["lang"] .. "d" })
      end
    end
  },

}
