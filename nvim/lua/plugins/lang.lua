------------------------------------------------------------------------------
-- language specific
------------------------------------------------------------------------------

return {
  {
    'habamax/vim-asciidoctor',
    lazy = false,
    ft = { "asciidoc", "asciidoctor" },
    keys = {
      { _MAPPING_PREFIX["lang"] .. "p", "<cmd>AsciidoctorOpenRAW<CR>", desc = "preview"}
    },
    config = function()
      -- NOTE: handlr can not handle asciidoc file.
      -- It recognize it as text file.
      local browser = os.getenv("BROWSER")
      if browser == nil then
        browser = "firefox"
      end
      vim.g.asciidoctor_opener = "!" .. browser

      vim.g.asciidoctor_folding = 1
      vim.g.asciidoctor_syntax_indented = 1
      vim.g.asciidoctor_fenced_languages = {
        'html', 'python', 'java', 'sh', 'ruby', "dockerfile", 'sql'
      }
      vim.g.asciidoctor_syntax_conceal = 1
    end
  },
  {
    'lervag/vimtex',
    lazy = true,
    ft = { "tex" },
    dependencies = {
      'folke/which-key.nvim'
    },
    config = function()
      -- TODO: vimtex integration not finished <2022-04-22, Hyunjae Kim> --

      -- neovim-remote needed
      vim.g.vimtex_compiler_progname = 'nvr'
      -- to use synctex in neovim / neovim-remote(pip3) should be installed
      -- Synctex synchronize the position of the editor and viewer
      -- let g:vimtex_quickfix_mode=0

      vim.opt_local.smartindent = false
      -- vim.opt_local.cindent = false
      -- vim.opt_local.autoindent = false
      vim.cmd([[
      set nocindent
      set noautoindent
      ]])
      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_indent_bib_enabled = 1

      -- Plugin : VIMTEX Settings
      vim.g.tex_flavor = "latex"
      if vim.fn.has('mac') == 1 then
        vim.g.vimtex_view_method = 'skim'
      else
        vim.g.vimtex_view_method = 'zathura'
      end

      -- SYNTAX HIGHLIGHTING
      vim.g.vimtex_syntax_enabled = 1
      -- let g:vimtex_syntax_nested =1

      -- Folding
      vim.g.vimtex_fold_enabled = 1
      vim.cmd([[set foldlevel 6]])
      -- vim.opt_local.foldlevel = 6 -- using vimtex's foldmethod

      -- COMPLETE FILEs
      vim.g.vimtex_complete_enabled = 1
      vim.g.vimtex_complete_close_braces = 1 -- default 0 (2021-01-16)

      -- let g:vimtex_indent_delims " not working don't know why
      -- let g:vimtex_indent_ignored_envs
      -- let g:vimtex_indent_lists "not working_don't know why
      -- let g:vimtex_indent_on_ampersands=1

      -- After installing Plug-tex-conceal
      -- vim.opt_local.conceallevel=2

      local status_wk, wk = pcall(require, "which-key")
      if status_wk then
        wk.register(
          {
            ["i"] = { "<plug>(vimtex-info)", "info" },
            ["I"] = { "<plug>(vimtex-info-full)", "info-full" },
            ["t"] = { "<plug>(vimtex-toc-toggle)", "toc-toggle" },
            ["q"] = { "<plug>(vimtex-log)", "log" },
            ["v"] = { "<plug>(vimtex-view)", "view" },
            ["r"] = { "<plug>(vimtex-reverse-search)", "reverse-search" },

            ["s"] = { "<plug>(vimtex-compile)", "compile" },
            -- ["sS"] = { "<plug>(vimtex-compile-selected)", "compile-selected", mode = "x", buffer = 0 },
            -- ["sS"] = { "<plug>(vimtex-compile-selected)", "compile-selected", mode = "x", buffer = 0 },

            ["w"] = { ":<C-u>VimtexCountWords", "count-words" },
            ["l"] = { ":<C-u>VimtexCountLetters", "count-letters" },
          },
          { buffer = 0, prefix = _MAPPING_PREFIX["lang"] }
        )
      end
    end
  },
  { 'rust-lang/rust.vim', lazy = true, ft = { 'rust' }, },
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
