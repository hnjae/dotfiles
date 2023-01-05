-- lsp

local use_native_lsp = true

local coc_config = function()
  ------------------------------------------------------------------------------
  -- override default setting
  -- coc needs these configs to work
  ------------------------------------------------------------------------------
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
  vim.opt.shortmess:append("c")

  -- Always show the signcolumn, otherwise it would shift the text each time
  -- diagnostics appear/become resolved.
  if vim.fn.has("nvim-0.5.0") == 1 then
    -- Recently vim can merge signcolumn and number column into one
    vim.opt.signcolumn = "number"
  else
    vim.optsigncolumn= "yes"
  end

  -- to use coc-highlight
  vim.opt.termguicolors = true

  ------------------------------------------------------------------------------
  -- autocmd set
  ------------------------------------------------------------------------------
  vim.cmd([[
  autocmd CursorHold * silent call CocActionAsync('highlight')
  ]])

  -- Auto complete
  function _G.check_back_space()
      local col = vim.fn.col('.') - 1
      return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
  end

  ----------------------------------------------------------------------
  -- 아래 리스트는, 설치 안되있으면 자동으로 설치됨
  -- :CocList extensions 으로 설치된 extensions 확인 가능
  -- coc-tabnin (all-language autocompleter)

  -- \ 'coc-diagnostic',
  -- https://github.com/neoclide/coc.nvim/wiki/Language-servers
  vim.g.coc_global_extensions = {
    -- "coc-lists",
    "coc-ultisnips",
    -- "coc-yank",
    -- "coc-explorer",
    -- "coc-spell-checker",
    "coc-prettier",
    -- "coc-dictionary",
    -- "coc-word",
    "coc-emoji",
    -- 'coc-highlight',

    -- markup language
    "coc-css",
    -- "coc-html",
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
    -- 'coc-lua',
    'coc-sh',

    --
    'coc-prettier',
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

end


return {
  -----------------------------------------------------------------------------
  -- coc
  -----------------------------------------------------------------------------
  {
    'neoclide/coc.nvim',
    branch = 'release',
    lazy = false,
    enabled = not use_native_lsp,
    cond = vim.fn.has("node") == 1,
    config = coc_config
  },
  {
    'antoinemadec/coc-fzf',
    branch = 'release',
    lazy = false,
    dependenceis = { 'neoclide/coc.nvim' },
    enabled = not use_native_lsp,
    cond = vim.fn.has("node") == 1,
  },

  -----------------------------------------------------------------------------
  -- native lsp
  -----------------------------------------------------------------------------
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    enabled = use_native_lsp,
  },
  {
    "simrat39/symbols-outline.nvim",
    enabled = use_native_lsp,
      config=function()
        local opts = {
          width = 17
        }
        require("symbols-outline").setup(opts)
    end
  },
  {
    'rcarriga/nvim-notify',
    enabled = use_native_lsp,
  },
  {
    'tamago324/nlsp-settings.nvim',
    lazy = true,
    enabled = use_native_lsp,
    dependenceis = {
      'neovim/nvim-lspconfig',
      'rcarriga/nvim-notify',
      'williamboman/nvim-lsp-installer'
    },
  },
  {
    'williamboman/nvim-lsp-installer',
    lazy = true,
    enabled = use_native_lsp,
    dependenceis = { 'neovim/nvim-lspconfig' },
  },
  -- use { 'nvim-lua/lsp-status.nvim' } -- lualine 에서 setup 해야함.
  -- it shows popup window.
  {
    'ray-x/lsp_signature.nvim',
    lazy = true,
    enabled = use_native_lsp,
    config = function() require('lsp_signature').setup() end,
  },
  {
    'onsails/lspkind.nvim',
    enabled = use_native_lsp,
  }, -- it shows kind icons
}
