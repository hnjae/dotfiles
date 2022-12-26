-- https://develop.spacemacs.org/layers/+lang/python/README.html

-- autocmd Filetype python setlocal python_highlight_all=1
-- let python_highlight_all=1 " 이거 키면 공백이 하이라이트 되는 게 짜증나
-- let python_space_error_highlight=0
-- let python_highlight_space_errors = 0

-- 7.4 Refactoring
-- fix a missing import statement with importmagic
-- remove unused imports (with autoflake for e.g.)
-- nmap sri
-- sort imports
--------------------------------------------------------------------------
-- TODO: REPL, rope, breakpoints <2021-11-16, Hyunjae Kim> "
-- rope 는 coc로도 가능한듯! -> coc-pyright 에 있음.
--------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Indent & Colorcolumn
-------------------------------------------------------------------------------
-- indent 관련 설정은 python-mode 에서 함.
-- vim.opt_local.softtabstop = 4
-- vim.opt_local.shiftwidth = 4
-- vim.opt_local.expandtab = true
-- vim.opt_local.autoindent = false
-- vim.opt_local.cindent = false
-- vim.opt_local.smartindent = false
vim.opt_local.foldmethod = "indent"
-- vim.opt_local.foldlevel = 9
vim.opt_local.colorcolumn = vim.fn.join(vim.fn.range(80, 999), ",")

------
-- for test
-----
-- vim.cmd([[
--   setlocal complete+=t
--   setlocal formatoptions -=t
-- ]])

-------------------------------------------------------------------------------
local status_wk, wk = pcall(require, "which-key")
if status_wk then
  wk.register(
    {
      p = { pame = "+pymode" },
      -- s = { name = "+inferior-repl-process" },
      -- v = { name = "+environments" },
      -- h = { name = "+help" },
      -- t = { name = "+test" },
    },
    { prefix = _LANG_PREFIX, buffer = 0 }
  )
end

-------------------------------------------------------------------------------
-- python-mode
-------------------------------------------------------------------------------
-- python-mode 가 특정 ft에서 실행하도록 되어서 그런가 loaded 체크 하면 작동이 안됨.
-- 지금으 될수도 있음.
if _IS_PLUGIN('python-mode') then
  vim.g.pymode_rope_regenerate_on_write = 1
  vim.g.pymode_warnings = 1

  -- Whitespace 기능은 다른 extension 으로 수행함.
  vim.g.pymode_trim_whitespaces = 0

  -- setup default python options (disabled)
  -- 짜증나는 옵션이 있어 끔.
  vim.g.pymode_options = 0

  vim.g.pymode_options_max_line_length = 79
  vim.g.pymode_options_colorcolumn = 0

  vim.g.pymode_quickfix_maxheight = 6
  -- vim.g.pymode_preview_height = 6

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
  vim.g.pymode_doc_bind = 'sph'

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
  vim.g.pymode_run_bind = _LANG_PREFIX .. 'pc'

  ------------------------------------------------------------------------------
  -- 2.8 Breakpoints
  ------------------------------------------------------------------------------
  vim.g.pymode_breakpoint = 0
  vim.g.pymode_breakpoint_bind = _LANG_PREFIX .. 'pb'

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
  vim.g.pymode_rope_autoimport_bind = _LANG_PREFIX .. 'rf'
  -- TODO:
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

-------------------------------------------------------------------------------
-- lsp
-------------------------------------------------------------------------------

if _IS_PLUGIN('autoflake.vim') then
  local mapping = { [_LANG_PREFIX .. "ra"] = { '<cmd>Autoflake --remove-all-unused-imports<CR>',
    "autoflake-remove-imports" }, }
  wk.register(mapping, { buffer = 0, noremap = false, mode = "n" })
end

local mapping = {
  [_LANG_PREFIX .. "rC"] = {
    '<cmd>Autoflake --remove-all-unused-imports<CR><cmd>Isort<CR><cmd>Black<CR>',
    "clean"
  },
}

wk.register(mapping, { buffer = 0, noremap = false, mode = "n" })

if _IS_PLUGIN('coc.nvim') then
  ----------------------------------------------------------------
  -- Formatting (==)
  ----------------------------------------------------------------
  -- python lsp does not support "Format Selection"
  -- vim.api.nvim_buf_set_keymap(0, "x", "==", "<plug>(coc-format-selected)", {})
  mapping = {
    [_LANG_PREFIX .. "ri"] = { ":call CocAction('organizeImport')<CR>", "organize-import" },
    -- ["=="] = { "<plug>(coc-format)", "coc-format" },
  }
  wk.register(mapping, { buffer = 0, noremap = false, mode = "n" })
  -- vim.api.nvim_buf_del_user_command(0, "Black")
  -- vim.api.nvim_buf_del_user_command(0, "Isort")
  vim.api.nvim_buf_create_user_command(0, "Black", ":CocCommand editor.action.formatDocument", {})
  vim.api.nvim_buf_create_user_command(0, "Isort", ":call CocAction('organizeImport')", {})

else
  if _IS_PLUGIN('isort.vim') then
    mapping = { [_LANG_PREFIX .. "ri"] = { '<cmd>Isort<CR>', "isort" }, }
    wk.register(mapping, { buffer = 0, noremap = false, mode = "n" })
    wk.register(mapping, { buffer = 0, noremap = false, mode = "v" })
  end
  if _IS_PLUGIN('black') then
    wk.register(
      { ["=="] = { '<cmd>Black<CR>', "black" }, },
      { buffer = 0, noremap = false, mode = "n" }
    )
  end
  require('user.lsp').setup({"pylsp", "pyright"})
end

-- local has_dap_python, dap_python require('dap-python')
-- local dap_mapping = {
--   tm = { dap_python.test_method, "test-method"},
--   tc = { dap_python.test_class, "test-class"},
--   -- s = { dap_python.test_method, "debug-selection"},
-- }
-- if has_dap_python then
--   -- wk.register(dap_mapping, { buffer = 0, noremap=false, mode = "n", prefix = _LANG_PREFIX .. "d" })
-- end

----------------------------------------------------------------
vim.cmd([[TagbarOpen]])
