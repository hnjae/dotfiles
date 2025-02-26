local prefix = require("val").prefix

---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("python", "requirements")
    end,
  },
  {
    -- :h conform-formatters
    -- https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft.python = {
        "ruff_fix",
        "ruff_organize_imports",
        "ruff_format",
      }
    end,
  },
  {
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        --[[
          NOTE:
            ## Comparison of LSPs for Python in 2025-02-23

            - pylyzer:
              - Fast static code analyzer & language server for Python
              - https://langserver.org/ 에 기재 X <2025-02-23>
              - 타입 추론 제공 X <2025-02-23>
              - "textDocument/rename" 는 지원한다고 인식하나, 작동하지 않는다. 이건 lspconfig 쪽 이슈일지도. <2025-02-23>
            - jedi_language_server: 매우 느리다 <2025-02-23>
            - pylsp:
            - pyright:
            - basedpyright:
        --]]

        -- 다음 셋 중 하나만 사용할 것.
        -- pylsp = {
        --   --   document 없음
        --   --   -- https://github.com/python-lsp/python-lsp-server
        --   ---@class LspconfigSetupOptsSpec
        --   settings = {},
        -- },
        ---@class LspconfigSetupOptsSpec
        pyright = {
          settings = {},
        },
        ---@class LspconfigSetupOptsSpec
        basedpyright = {
          settings = {},
        },

        -- 타입 추론 제공 X LSP:
        ---@class LspconfigSetupOptsSpec
        ruff = {
          -- linter and formatter
          init_options = {
            settings = {
              configurationPreference = "filesystemFirst",
              -- lineLength = 79,
            },
          },
          settings = {},
        },

        ---@class LspconfigSetupOptsSpec
        pyre = {
          -- a static type checker for Python 3.
          settings = {},
        },
      },
    },
  },
  {
    [1] = "nvimtools/none-ls.nvim",
    optional = true,
    -- dependencies = {
    --   https://github.com/nvimtools/none-ls-extras.nvim
    -- }
    opts = function(_, opts)
      local null_ls = require("null-ls")

      local mapping = {
        -- a static analysis tool for checking compliance with Python docstring conventions.
        mypy = { -- static typing checker
          null_ls.builtins.diagnostics.mypy.with({
            -- diagnostics_format = "[#{s}] #{m}",
            diagnostics_postprocess = function(diagnostic)
              diagnostic.message = "["
                .. diagnostic.source
                .. "] "
                .. diagnostic.message

              -- dirty hacks
              local ignore_msg =
                "module is installed, but missing library stubs or py.typed marker"
              if diagnostic.message:match(ignore_msg .. "$") then
                diagnostic.severity = vim.diagnostic.severity.HINT
              end
            end,

            -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1208
            runtime_condition = function(params)
              return require("null-ls.utils").path.exists(params.bufname)
            end,
          }),
        },
      }

      for exe, sources in pairs(mapping) do
        if vim.fn.executable(exe) == 1 then
          vim.list_extend(opts.sources, sources)
        end
      end
    end,
  },
  {
    [1] = "python-mode/python-mode",
    lazy = true,
    branch = "develop",
    enabled = false,
    cond = vim.fn.has("python3") == 1,
    ft = { "python" },
    init = function()
      vim.g.pymode_rope_regenerate_on_write = 1

      vim.g.pymode_warnings = 1
      vim.g.pymode_trim_whitespaces = 0
      vim.g.pymode_options = 0 -- setup default python options (disabled)

      -- vim.g.pymode_options_max_line_length = 79
      vim.g.pymode_options_colorcolumn = 0

      vim.g.pymode_quickfix_maxheight = 6

      vim.g.pymode_indent = 1
      -- 2022-01-01 folding 공식문서에서 잘 안됨다고.
      vim.g.pymode_folding = 0

      ---------------------------------------------------
      -- pymode-motion
      ---------------------------------------------------
      vim.g.pymode_motion = 1

      ---------------------------------------------------
      -- doc
      ---------------------------------------------------

      vim.g.pymode_doc = 1
      vim.g.pymode_doc_bind = prefix.buffer .. "ph"

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
      vim.g.pymode_run_bind = prefix.buffer .. "pc"

      ------------------------------------------------------------------------------
      -- 2.8 Breakpoints
      ------------------------------------------------------------------------------
      vim.g.pymode_breakpoint = 0
      vim.g.pymode_breakpoint_bind = prefix.buffer .. "pb"

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
      vim.g.pymode_rofe_refix = "sr"

      -- TODO: show_doc 활용할까? <2022-04-23, Hyunjae Kim> --
      vim.g.pymode_rope_show_doc_bint = ""

      -- 4.1 Completion
      vim.g.pymode_rope_completion = 0
      vim.g.pymode_rope_completion_on_dot = 0
      vim.g.pymode_rope_completion_bind = ""
      vim.g.pymode_rope_autoimport = 1
      vim.g.pymode_rope_autoimport_modules = {
        "os",
        "shutil",
        "datetime",
        "subprocess",
        "typing",
        "pathlib",
      }
      vim.g.pymode_rofe_autoimport_after_complete = 1

      -- 4.2 find definition
      vim.g.pymode_rope_goto_definition_bind = ""

      -- 4.3 refactoring
      vim.g.pymode_rope_rename_bind = ""
      vim.g.pymode_rope_rename_module_bind = ""
      vim.g.pymode_rope_organize_imports_bind = ""
      vim.g.pymode_rope_autoimport_bind = prefix.buffer .. "rf"
      vim.g.pymode_rope_module_to_package_bind = ""
      vim.g.pymode_rope_extract_method_bind = ""
      vim.g.pymode_rope_extract_variable_bind = ""
      vim.g.pymode_rope_use_function_bind = ""
      vim.g.pymode_rope_move_bind = ""
      vim.g.pymode_rope_change_signature_bind = ""

      ------------------------------------------------------------------------------
      -- 5. syntax
      ------------------------------------------------------------------------------
      -- use neovim's feature
      vim.g.pymode_syntax = 0
      vim.g.pymode_syntax_all = 0
    end,
    config = function()
      local status_wk, wk = pcall(require, "which-key")
      if not status_wk then
        return
      end

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
          ["V"] = "logical-line",
          -- 다음은 help에 없는데 which-key에 뜨는 값
          ["C"] = "class",
          ["M"] = "function/method",
        }
        wk.register(omap, { mode = "o", buffer = 0, silent = true })
        local xmap = {
          -- help 에는 operator 이라고 적혀있지만 visual 도 있는 맵핑
          ["aM"] = "function/method",
          ["iM"] = "inner-function/method",
        }
        wk.register(xmap, { mode = "x", buffer = 0, silent = true })
      end
    end,
  },
}
