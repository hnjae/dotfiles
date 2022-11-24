-- TODO: vimtex integration not finished <2022-04-22, Hyunjae Kim> --
-- UI
vim.opt_local.colorcolumn = "0"

--  Tabs
-- syntatic's chktex will not work if tabstop is not 8
vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- INDENTATION
vim.opt_local.smartindent = false
vim.opt_local.cindent = false
vim.opt_local.autoindent = false
vim.g.vimtex_indent_enabled = 1
vim.g.vimtex_indent_bib_enabled = 1

-- Plugin : VIMTEX Settings
vim.g.tex_flavor = "latex"
if vim.fn.has('mac') == 1 then
  vim.g.vimtex_view_method = 'skim'
else
  vim.g.vimtex_view_method = 'zathura'
end

-- neovim-remote needed
vim.g.vimtex_compiler_progname = 'nvr'
-- to use synctex in neovim / neovim-remote(pip3) should be installed
-- Synctex synchronize the position of the editor and viewer
-- let g:vimtex_quickfix_mode=0

-- SYNTAX HIGHLIGHTING
vim.g.vimtex_syntax_enabled = 1
-- let g:vimtex_syntax_nested =1

-- Folding
vim.g.vimtex_fold_enabled = 1
vim.opt_local.foldlevel = 6 -- using vimtex's foldmethod

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
      ["i"] = { "<plug>(vimtex-info)", "info"},
      ["I"] = { "<plug>(vimtex-info-full)", "info-full"},
      ["t"] = { "<plug>(vimtex-toc-toggle)", "toc-toggle"},
      ["q"] = { "<plug>(vimtex-log)", "log"},
      ["v"] = { "<plug>(vimtex-view)", "view"},
      ["r"] = { "<plug>(vimtex-reverse-search)", "reverse-search" },

      ["s"] = { "<plug>(vimtex-compile)", "compile" },
      -- ["sS"] = { "<plug>(vimtex-compile-selected)", "compile-selected", mode = "x", buffer = 0 },
      -- ["sS"] = { "<plug>(vimtex-compile-selected)", "compile-selected", mode = "x", buffer = 0 },

      ["w"] = { ":<C-u>VimtexCountWords", "count-words"},
      ["l"] = { ":<C-u>VimtexCountLetters", "count-letters"},
    },
    {buffer = 0, prefix=_LANG_PREFIX}
  )
end
