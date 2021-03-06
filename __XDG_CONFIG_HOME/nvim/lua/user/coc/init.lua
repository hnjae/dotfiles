local M = {}
M.setup = function()
  require("user.coc.override-defaults").setup()

  ----------------------------------------------------------------------
  -- 아래 리스트는, 설치 안되있으면 자동으로 설치됨
  -- :CocList extensions 으로 설치된 extensions 확인 가능
  -- coc-tabnin (all-language autocompleter)

  -- \ 'coc-diagnostic',
  -- https://github.com/neoclide/coc.nvim/wiki/Language-servers
  vim.g.coc_global_extensions = {
    "coc-lists",
    "coc-ultisnips",
    "coc-yank",
    "coc-explorer",
    "coc-spell-checker",
    "coc-prettier",
    "coc-dictionary",
    -- "coc-word",
    "coc-emoji",
    -- 'coc-highlight',
    -- markup language
    "coc-css",
    "coc-html",
    -- "coc-ansible",
    "coc-docker",
    "coc-yaml",
    'coc-vimtex',
    'coc-json',
    -- language
    'coc-vimlsp',
    'coc-rls',
    'coc-pyright',
    'coc-jedi',
    'coc-sumneko-lua',
    'coc-sh',
  }

  -- coc-snippets
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

  -- Highlight the symbol and its references when holding the cursor.

  -- if "coc-highlight" in  vim.g.coc_global_extensions then
  --   vim.api.nvim_create_autocmd(
  --     {
  --       "CursorHold"
  --     },
  --     {
  --       pattern = {"*"},
  --       callback = function()
  --         vim.fn.CocActionAsync("highlight")
  --       end
  --     }
  --   )
  -- end

  require("user.coc.keymap").setup()
end

return M
