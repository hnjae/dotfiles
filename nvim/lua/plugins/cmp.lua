local nvim_cmp_spec = {
  'hrsh7th/nvim-cmp',
  lazy = true,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    { 'onsails/lspkind.nvim', }, -- adds vscode-like pictograms to built-in lsp
    { 'hrsh7th/cmp-nvim-lsp', },
    { 'hrsh7th/cmp-nvim-lsp-document-symbol', },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', },
    { 'hrsh7th/cmp-path', },
    { 'hrsh7th/cmp-buffer', },
    { 'hrsh7th/cmp-cmdline', },
    {
      'quangnguyen30192/cmp-nvim-ultisnips',
      dependencies = { 'sirver/ultisnips' },
    },
    --
    { 'hrsh7th/cmp-nvim-lua', },
  },
}

nvim_cmp_spec.config = function()
  local cmp = require("cmp")

  local cmp_opts = {
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      -- ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    sources = cmp.config.sources(
      { { name = 'buffer' }, },
      {
        { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'snippy' }, -- For snippy users.
        -- { name = 'orgmode' },
      },
      { { name = 'nvim_lsp' }, },
      { { name = 'nvim_lsp_document_symbol' }, },
      { { name = 'nvim_lsp_signature_help' }, },
      { { name = 'path' } }
    ),

    formatting  = {
      format = require("lspkind").cmp_format({ mode = 'symbol', })
    }
  }

  cmp.setup(cmp_opts)

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(
    { '/', '?' },
    {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = 'buffer' } }
    }
  )

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(
    ':',
    {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        { { name = 'path' } }, { { name = 'cmdline' } }
      )
    }
  )

  -- Set configuration for specific filetype.
  cmp.setup.filetype(
    'gitcommit',
    {
      sources = cmp.config.sources(
        { { name = 'cmp_git' }, }, -- You can specify the `cmp_git` source if you were installed it.
        { { name = 'buffer' }, }
      )
    }
  )
end

return {
  nvim_cmp_spec,
}
