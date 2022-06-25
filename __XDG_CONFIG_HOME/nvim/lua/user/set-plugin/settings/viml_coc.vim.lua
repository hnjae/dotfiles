if _IS_PLUGIN('coc.nvim') then
  -- coc must have config
  -- if hidden is not set, TextEdit might fail.
  vim.opt.hidden = true

  -- Some servers have issues with backup files, see #649
  vim.opt.backup = false
  vim.opt.writebackup = false

  -- Better display for messages
  vim.opt.cmdheight = 2

  -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  -- delays and poor user experience.
  vim.opt.updatetime=300

  -- Don't pass messages to |ins-completion-menu|.
  vim.opt.shortmess:append "c"

  -- Always show the signcolumn, otherwise it would shift the text each time
  -- diagnostics appear/become resolved.
  if vim.fn.has("nvim-0.5.0") then
    -- Recently vim can merge signcolumn and number column into one
    vim.opt.signcolumn = "number"
  else
    vim.optsigncolumn= "yes"
  end

  ----------------------------------------------------------------------
  -- 아래 리스트는, 설치 안되있으면 자동으로 설치됨
  -- :CocList extensions 으로 설치된 extensions 확인 가능
  -- let g:coc_global_extensions = ['coc-explorer', 'coc-json', 'coc-tsserver', 'coc-import-cost', 'coc-eslint', 'coc-snippets', 'coc-template', 'coc-html', 'coc-css', 'coc-emmet', 'coc-pyright', 'coc-phpls', 'coc-angular', 'coc-git']
  -- let g:coc_global_extensions = ['coc-explorer', 'coc-json', 'coc-tsserver',
  -- 'coc-import-cost', 'coc-eslint', 'coc-snippets', 'coc-template', 'coc-html',
  -- 'coc-css', 'coc-emmet', 'coc-pyright', 'coc-phpls', 'coc-angular',
  -- 'coc-git']let g:coc_global_extensions += ['https://github.com/andys8/vscode-jest-snippets']
  -- coc-tabnin (all-language autocompleter)

  -- \ 'coc-diagnostic',
  vim.g.coc_global_extensions = {
    -- neoclide
    -- document highlight & colors highlight
    'coc-highlight',

    -- neoclide
    'coc-snippets',
    'coc-java',
    'coc-vimtex',

    -- neoclide
    'coc-json',

    'coc-lists',
    'coc-vimlsp',
    'coc-rls',

    -- fannheyward
    'coc-pyright',

    --
    'coc-sumneko-lua',

    -- josa42
    -- uses bash-language-server
    'coc-sh',
  }

  -- coc-snippets
  local wk = require("which-key")
  -- default C-l
  -- vim.api.nvim_set_keymap("i", "<tab>", "<plug>(coc-snippets-expand)", {})
  -- default C-j
  -- vim.api.nvim_set_keymap("v", "<tab>", "<plug>(coc-snippets-select)", {})
  -- vim.g.coc_snippet_next = '<tab>'
  -- vim.g.coc_snippet_prev = '<s-tab>'
  -- vim.api.nvim_set_keymap("i", "<tab>", "<plug>(coc-snippets-expand-jump)", {})
  -- xmap <leader>x  <Plug>(coc-convert-snippet)
  -- vim.cmd([[
  -- function! s:check_back_space() abort
  -- let col = col('.') - 1
  -- return !col || getline('.')[col - 1]  =~# '\s'
  -- endfunction

  -- inoremap <silent><expr> <TAB>
  -- \ pumvisible() ? coc#_select_confirm() :
  -- \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  -- \ <SID>check_back_space() ? "\<TAB>" :
  -- \ coc#refresh()

  -- let g:coc_snippet_next = '<tab>'
  -- ]])


  -- to use coc-highlight
  vim.opt.termguicolors = true

  -- Highlight the symbol and its references when holding the cursor.
  vim.cmd([[
  autocmd CursorHold * silent call CocActionAsync('highlight')
  ]])

  -- Add (Neo)Vim's native statusline support.
  -- Airline 쓰고 있으니 필요 없을듯 함.
  -- NOTE: Please see `:h coc-status` for integrations with external plugins that
  -- provide custom statusline: lightline.vim, vim-airline.
end
