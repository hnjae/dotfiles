-- autocmd StdinReadPre * let s:std_in=1
-- autocmd VimEnter * if argc() == 0 && !exists(“s:std_in”) | NERDTree | endif
if _IS_PLUGIN('nerdtree') then
  vim.g.NERDTreeHijackNetrw=0
  vim.g.NERDTreeMinimalUI = 0
  vim.g.NERDTreeDirArrows = 1
  vim.g.NERDTreeQuitOnOpen = 1
  vim.g.NERDTreeShowHidden=1
end
-- autocmd bufenter * if (winnr(“$”) == 1 && exists(“b:NERDTreeType”) && b:NERDTreeType == “primary”) | q | endif
-- https://medium.com/@victormours/a-better-nerdtree-setup-3d3921abc0b9
