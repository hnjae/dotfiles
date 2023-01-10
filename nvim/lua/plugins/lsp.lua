-- lsp
-- local use_native_lsp = true

local mason_lspconfig_spec = {
  'williamboman/mason-lspconfig.nvim',
  lazy = false,
  priority = 1,
  dependencies = {
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
    dependencies = {
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
    lazy = true,
    enabled = true,
    module = true,
  },
  {
    -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
    'folke/trouble.nvim',
    lazy = false,
    enabled = true,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'williamboman/mason-lspconfig.nvim',
    }
  },
  {
    -- TODO: chick this out! <2023-01-08, Hyunjae Kim>
    'jose-elias-alvarez/null-ls.nvim',
    lazy = false,
  },
  mason_lspconfig_spec,


  -- https://github.com/sbdchd/neoformat
  -- https://github.com/mhartington/formatter.nvim
  -- https://github.com/folke/lsp-colors.nvim

  ------------------------------------------------------------------------------
  -- dap
  ------------------------------------------------------------------------------
  {
    'mfussenegger/nvim-dap',
    lazy = false,
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
    lazy = false,
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


  ------------------------------------------------------------------------------
  -- language specific
  ------------------------------------------------------------------------------
  {
    'python-mode/python-mode',
    lazy = true,
    branch = 'develop',
    cond = vim.fn.has('python3'),
    dependencies = {
      'folke/which-key.nvim'
    },
    ft = { 'python' },
    config = function()
      local wk = require("which-key")

      vim.g.pymode_rope_regenerate_on_write = 1

      vim.g.pymode_warnings = 1
      vim.g.pymode_trim_whitespaces = 0
      vim.g.pymode_options = 0 -- setup default python options (disabled)

      -- vim.g.pymode_options_max_line_length = 79
      vim.g.pymode_options_colorcolumn = 0

      vim.g.pymode_quickfix_maxheight = 6

      vim.g.pymode_indent = 1
      -- 2022-01-01 folding 잘 안됨 공식문서에서
      vim.g.pymode_folding = 0

      ---------------------------------------------------
      -- pymode-motion
      ---------------------------------------------------
      vim.g.pymode_motion = 1
      if vim.g.pymode_motion == 1 then
        local nomap = {
          -- 다음은 help에 없는데 which-key에 뜨는 값
          ["[C"] = "class/function", -- normal, operator
          ["]C"] = "class/function", -- normal, operator
        }
        wk.register(nomap, { mode = "n", buffer = 0, silent = true })
        wk.register(nomap, { mode = "o", buffer = 0, silent = true })
        local nxomap = {
          ["[["] = "class/function", -- normal, visual, operator
          ["]]"] = "class/function", -- normal, visual, operator
          ["[M"] = "class/method-end", -- normal, visual, operator
          ["]M"] = "class/method-end", -- normal, visual, operator
          -- 다음은 help에 없는데 which-key에 뜨는 값
          -- python-mode의 python.vim 에 없어서 어디서 정의되는지 모르겠음. (2022-04-21)
          -- ["[m"] =  "class/method", -- normal, visual, operator
          -- ["]m"] =  "class/method", -- normal, visual, operator
        }
        wk.register(nxomap, { mode = "n", buffer = 0, silent = true })
        wk.register(nxomap, { mode = "x", buffer = 0, silent = true })
        wk.register(nxomap, { mode = "o", buffer = 0, silent = true })
        local omap = {
          ["aC"] = "class",
          ["iC"] = "inner=class",
          ["aM"] = "function/method",
          ["iM"] = "inner-function/method",
          ["V"]  = "logical-line",
          -- 다음은 help에 없는데 which-key에 뜨는 값
          ["C"]  = "class",
          ["M"]  = "function/method",
        }
        wk.register(omap, { mode = "o", buffer = 0, silent = true })
        local xmap = {
          -- help 에는 operator 이라고 적혀있지만 visual 도 있는 맵핑
          ["aM"] = "function/method",
          ["iM"] = "inner-function/method",
        }
        wk.register(xmap, { mode = "x", buffer = 0, silent = true })
      end

      -- coc 도 비슷한 기능 있는듯.
      vim.g.pymode_doc = 1
      vim.g.pymode_doc_bind = _MAPPING_PREFIX["lang"] .. 'ph'

      ------------------------------------------------------------------------------
      -- 2.6 Support Virtualenv
      ------------------------------------------------------------------------------

      vim.g.pymode_virtualenv = 1
      -- manually set virtualenv path
      -- vim.g.pymode_virtualenv_path =

      ------------------------------------------------------------------------------
      -- 2.7 Run code
      ------------------------------------------------------------------------------
      vim.g.pymode_run = 1
      vim.g.pymode_run_bind = _MAPPING_PREFIX["lang"] .. 'pc'

      ------------------------------------------------------------------------------
      -- 2.8 Breakpoints
      ------------------------------------------------------------------------------
      vim.g.pymode_breakpoint = 0
      vim.g.pymode_breakpoint_bind = _MAPPING_PREFIX["lang"] .. 'pb'

      ------------------------------------------------------------------------------
      -- 3. Code Checking
      ------------------------------------------------------------------------------
      vim.g.pymode_lint = 0

      ------------------------------------------------------------------------------
      -- 4. Rope
      ------------------------------------------------------------------------------
      -- TODO: rope 각종 에러떠서 비활성화 <2022-04-23, Hyunjae Kim> --
      -- 설정하기에 따라 사용은 가능할 것 같긴하다.
      vim.g.pymode_rope = 0
      vim.g.pymode_rofe_refix = 'sr'

      -- TODO: show_doc 활용할까? <2022-04-23, Hyunjae Kim> --
      vim.g.pymode_rope_show_doc_bint = ''

      -- 4.1 Completion
      vim.g.pymode_rope_completion = 0
      vim.g.pymode_rope_completion_on_dot = 0
      vim.g.pymode_rope_completion_bind = ''
      vim.g.pymode_rope_autoimport = 1
      vim.g.pymode_rope_autoimport_modules = {
        'os', 'shutil', 'datetime', 'subprocess',
        'typing', 'pathlib'
      }
      vim.g.pymode_rofe_autoimport_after_complete = 1

      -- 4.2 find definition
      vim.g.pymode_rope_goto_definition_bind = ''

      -- 4.3 refactoring
      vim.g.pymode_rope_rename_bind = ''
      vim.g.pymode_rope_rename_module_bind = ''
      vim.g.pymode_rope_organize_imports_bind = ''
      vim.g.pymode_rope_autoimport_bind = _MAPPING_PREFIX["lang"] .. 'rf'
      vim.g.pymode_rope_module_to_package_bind = ''
      vim.g.pymode_rope_extract_method_bind = ''
      vim.g.pymode_rope_extract_variable_bind = ''
      vim.g.pymode_rope_use_function_bind = ''
      vim.g.pymode_rope_move_bind = ''
      vim.g.pymode_rope_change_signature_bind = ''

      ------------------------------------------------------------------------------
      -- 5. syntax
      ------------------------------------------------------------------------------
      -- use neovim's feature
      vim.g.pymode_syntax = 0
      vim.g.pymode_syntax_all = 0
    end
  },
}
