return {
  -- vimL plugin
  { "dstein64/vim-startuptime" },
  { 'neoclide/jsonc.vim', lazy = true },
  { 'junegunn/fzf.vim', lazy = true, cond = vim.fn.executable("fzf") == 1 },
  -- repl/repl-like
  { 'michaelb/sniprun', lazy = true, build = 'bash ./install.sh' },
  -- run test
  { 'vim-test/vim-test', lazy = true },
  { 'vimwiki/vimwiki', lazy = true },
  -- m의 mark 가 보이게 해준다.
  {
    'kshenoy/vim-signature',
    lazy=false,
    config=function()
      --[[
        이유는 모르지만 vim-commentary 와 gc 에서 mapping 이 충돌.
        vim-surrounded
      --]]
      vim.g.SignatureMap = {
        -- ['Leader']            = "m",
        -- ['PlaceNextMark']     = "m,",
        -- ['ToggleMarkAtLine']  = "m.",
        -- ['PurgeMarksAtLine']  = "m-",
        -- ['PurgeMarks']        = "m<Space>",
        ['Leader']            = "m",
        ['PlaceNextMark']     = "",
        ['ToggleMarkAtLine']  = "",
        ['PurgeMarksAtLine']  = "",
        ['PurgeMarks']        = "",
        --
        ['PurgeMarkers']      = "",
        ['ListBufferMarks']   = "",
        ['ListBufferMarkers'] = "",
        ------
        ['DeleteMark']        = "",
        ------
        -- ['GotoNextLineAlpha']  =  "']",
        -- ['GotoPrevLineAlpha']  =  "'[",
        ['GotoNextLineAlpha'] = "", -- 기본 맵핑이 있음
        ['GotoPrevLineAlpha'] = "", -- 기본 맵핑이 있음
        ['GotoNextSpotAlpha'] = "", -- 기본 맵핑이 있음
        ['GotoPrevSpotAlpha'] = "", -- 기본 맵핑이 있음
        ------
        ['GotoNextLineByPos'] = "",
        ['GotoPrevLineByPos'] = "",
        ['GotoNextSpotByPos'] = "",
        ['GotoPrevSpotByPos'] = "",
        ['GotoNextMarker']    = "",
        ['GotoPrevMarker']    = "",
        ['GotoNextMarkerAny'] = "",
        ['GotoPrevMarkerAny'] = "",
      }

      local status_wk, wk = pcall(require, "which-key")
      if status_wk then
        wk.register({
          -- ["m,"] = { "place-next-mark" },
          -- ["m."] = { "toggle-mark-at-line" },
          -- ["m-"] = { "purge-marks-at-line" },
          -- ["m "] = { "purge-marks-at-buffer" },
          -- ["m/"] = { "list-buffer-marks" },
          -- ["m?"] = { "list-buffer-markers" },
          ----
          ["dm"] = { "delete-mark" },
          ----
          -- ["'["] = { "goto-prev-line-alpha" },
          -- ["']"] = { "goto-next-line-alpha" },
          -- ["`["] = { "goto-prev-spot-alpha" },
          -- ["`]"] = { "goto-next-spot-alpha" },
          ----
          -- ["]`"] = { "signature-spot-by-pos" },
          -- ["[`"] = { "signature-spot-by-pos" },
          -- ["['"] = { "signature-line-by-pos" },
          -- ["]'"] = { "signature-line-by-pos" },
          -- ["]-"] = { "signature-marker" },
          -- ["[-"] = { "signature-marker" },
          -- ["[="] = { "signature-marker-any" },
          -- ["]="] = { "signature-marker-any" },
        })
      end
    end
  },
  {
    'honza/vim-snippets',
    lazy=false,
    config=function()
      vim.g.snips_author = "Hyunjae Kim"
      vim.g.snips_email = "hyunjae.kim@gmx.com"
      vim.g.snips_github = "https://github.com/hnjae"
    end
  },
  { 'tpope/vim-surround'},
  { 'wfxr/minimap.vim', enabled = false },
  { 'johngrib/vim-f-hangul' },
  { 'ap/vim-css-color' },
  { 'tpope/vim-vinegar' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-fugitive' },
  {
    'habamax/vim-asciidoctor',
    config=function()
      -- TODO: use environment variable <2022-06-16, Hyunjae Kim>
      -- NOTE: handlr can not handle asciidoc file. It recognize it as text file.
      vim.g.asciidoctor_opener = "!firefox"

      vim.g.asciidoctor_folding = 1
      vim.g.asciidoctor_fenced_languages = {
        'html', 'python', 'java', 'sh', 'ruby', "dockerfile"
      }
      vim.g.asciidoctor_syntax_conceal = 1
    end
  },
  -- language
  { 'lervag/vimtex', lazy = true, ft = { "tex" } },
  { 'python-mode/python-mode', lazy = true, branch = 'develop', ft = { 'python' }, },
  { 'rust-lang/rust.vim', lazy = true, ft = { 'rust' }, },
  {
    'ludovicchabant/vim-gutentags',
    lazy=false,
    config=function()
      vim.g.gutentags_cache_dir = vim.fn.stdpath('cache') .. "/gutentags"
      vim.g.gutentags_exclude_filetypes = {
        '',
        'fugitive',
        'nerdtree',
        'tagbar',
        'help',
      }
    end
  },

  -- dev
  -- { "folke/neodev.nvim" },
  {
    'puremourning/vimspector',
    lazy=true,
    cond=vim.fn.has('python3'),
    config=function()
      vim.g.vimspector_install_gadgets = {
        "depugby"
      }
    end
  },
    -- use { 'mfussenegger/nvim-dap' }
    -- use { 'mfussenegger/nvim-dap-python' }


  -- editing experince
  {
    'sirver/ultisnips',
    lazy=false,
    cond=vim.fn.has('python3'),
    config=function()
      vim.api.nvim_set_keymap("i", "<c-x><c-k>", "<c-x><c-k>", {})

      -- vim.g.UltiSnipsExpandTrigger = '<tab>'
       -- let g:UltiSnipsListSnippets = '<c-tab>'
      vim.g.UltiSnipsJumpForwardTrigger = '<tab>'    -- default: <c-j>
      vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>' -- default: <c-k>
      -- vim.g.UltiSnipsEditSplit = "horizontal" -- if you want

      local ulti_dir = vim.fn.stdpath('config') .. "/UltiSnips"
      vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = ulti_dir

      vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }

      vim.g.UltiSnipsEditSplit = "context"
      vim.g.UltiSnipsEnableSnipMate = 0
    end
  },

  -- misc
  { 'h-hg/fcitx.nvim', cond = vim.fn.executable("fcitx5-remote") },
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    config=function()
      require("hop").setup { keys = 'etovxqpdygfblzhckisuran' }
    end

  },
  {
    "akinsho/toggleterm.nvim",
    tag='2.3.0',
    lazy=false,
    config=function()
      require("toggleterm").setup()
    end
  },
  { 'tiagofumo/vim-nerdtree-syntax-highlight', lazy=true },
  {
    'scrooloose/nerdtree',
    lazy=false,
    dependenceis = { 'tiagofumo/vim-nerdtree-syntax-highlight' },
    config=function()
      vim.g.NERDTreeHijackNetrw=0
      vim.g.NERDTreeMinimalUI = 0
      vim.g.NERDTreeDirArrows = 1
      vim.g.NERDTreeQuitOnOpen = 1
      vim.g.NERDTreeShowHidden=1
      -- autocmd bufenter * if (winnr(“$”) == 1 && exists(“b:NERDTreeType”) && b:NERDTreeType == “primary”) | q | endif
      -- https://medium.com/@victormours/a-better-nerdtree-setup-3d3921abc0b9
    end
  },
}
