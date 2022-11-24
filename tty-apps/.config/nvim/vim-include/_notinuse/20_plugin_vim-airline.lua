if packer_plugins['vim-airline'] and packer_plugins['vim-airline'].loaded then
  -- if vim.fn.exists('g:airline_symbols') then
  --   vim.g.airline_symbols = {}
  -- end
  vim.cmd([[
    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif
  ]])

  -- > 꺽쇠 쓸지 여부
  vim.g.airline_powerline_fonts = 1

  --
  vim.g.airline_symbols_ascii = 0


  -- SPELL 관한 설정
  -- vim.g["airline_symbols"]["spell"] = 'Ꞩ'
  vim.cmd([[let g:airline_symbols.spell = 'Ꞩ']])
  vim.g.airline_detect_spell = 1
  vim.g.airline_detect_spelllang = 0

  -- :AirlineTheme {theme-name}                                   *:AirlineTheme*

  -- coc <https://github.com/neoclide/coc.nvim>
  -- vim.cmd([[let g:airline#extensions#coc#enabled = 1]])
  vim.g["airline#extensions#coc#enabled"] = 1

  ---------------------------------------------
  -- EXTENSION - TAB LINE
  ---------------------------------------------
  -- tab line 에서 buffer number 를 보여준다
  vim.g["airline#extensions#tabline#enabled"] = 1
  -- let g:airline#extensions#tabline#buffer_nr_show = 1
  -- vim-airline 버퍼 목록에서 파일명만 출력
  vim.g["airline#extensions#tabline#fnamemod"] = ':t'

  -- tabline 에서 buffer number format
  vim.g["airline#extensions#tabline#buffer_nr_format"] = '%s:'

  -- rename label for tabs (default: 'tabs') (c) >
  vim.g["airline#extensions#tabline#tabs_label"] = 't'
  -- enable/disable displaying number of tabs in the right side (c) >
  vim.g["g:airline#extensions#tabline#show_tab_count"] = 0
  -- rename label for buffers (default: 'buffers') (c) >
  vim.g["airline#extensions#tabline#buffers_label"] = 'b'
  -- * enable/disable displaying open splits per tab (only when tabs are opened) >
  -- 이거 0 하면 버퍼 목록이 안뜸
  vim.g["airline#extensions#tabline#show_splits"] = 1

  -- change the symbol for skipped tabs/buffers (default '...') >
  -- let g:airline#extensions#tabline#overflow_marker = '…'
  -- let g:airline#extensions#tabline#show_tabs = 0

  ---------------------------------------------

  -- let g:airline#extensions#hunks#enabled = 0
  -- let g:airline#extensions#hunks#coc_git = 0
  -- let g:airline#extensions#whitespace#enabled=0
  -- let g:airline_detect_modified=0
  -- let g:airline_detect_crypt=0
  -- let g:airline_detect_paste=0


  -- UTF-8 이면 인코딩 표기 생략
  vim.g["airline#parts#ffenc#skip_expected_string"] = 'utf-8[unix]'

  vim.g["airline#extensions#keymap#enabled"] = 1
end
