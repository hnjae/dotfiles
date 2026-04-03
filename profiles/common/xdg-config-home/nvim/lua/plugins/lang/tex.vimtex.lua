---@type LazySpec
return {
  [1] = "vimtex",
  opts = function()
    -- WIP: vimtex integration <2022-04-22, Hyunjae Kim> --
    -- neovim-remote needed
    vim.g.vimtex_compiler_progname = "nvr"
    -- to use synctex in neovim / neovim-remote(pip3) should be installed
    -- Synctex synchronize the position of the editor and viewer
    -- let g:vimtex_quickfix_mode=0

    vim.opt_local.smartindent = false
    vim.g.vimtex_indent_enabled = 1
    vim.g.vimtex_indent_bib_enabled = 1

    -- Plugin : VIMTEX Settings
    vim.g.tex_flavor = "latex"
    if vim.fn.has("mac") == 1 then
      vim.g.vimtex_view_method = "skim"
    else
      vim.g.vimtex_view_method = "zathura"
    end

    -- SYNTAX HIGHLIGHTING
    vim.g.vimtex_syntax_enabled = 1
    -- let g:vimtex_syntax_nested =1

    -- Folding
    vim.g.vimtex_fold_enabled = 1
    -- vim.cmd([[set foldlevel 6]])
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
  end,
}
