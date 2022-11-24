-- https://github.com/wfxr/minimap.vim

if packer_plugins['minimap.vim'] and packer_plugins['minimap.vim'].loaded then
  -- default 10
  vim.g.minimap_width = 8

  -- let g:minimap_auto_start_win_enter=1
  -- \ 'help',

  -- Default: fugitive, nerdtree, tagbar
    -- 'startify',
  vim.g.minimap_block_filetypes = {
    'fugitive',
    'nerdtree',
    'tagbar',
    'help'
  }

  -- Default: `['startify', 'netrw', 'vim-plug']`
  vim.g.minimap_close_filetypes = {
    'startify',
    'netrw',
    'vim-plug',
  }

  -- TODO: auto open minimap if columns are enough to open
  -- if vim.o.columns > 80 then
  --   print("1")
  --   vim.w.minimap_auto_start = 1
  -- end

  -- autocmd FileType help setlocal minimap_auto_start=0
  vim.g.minimap_auto_start = 0
  vim.g.minimap_auto_start_win_enter = 1
end
