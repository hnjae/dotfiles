local icons = {
  -- Text = "",
  -- Text = "",
  Text = "-",
  Method = "",
  -- Function = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

return {
  "hrsh7th/nvim-cmp",
  lazy = false,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    -- { "onsails/lspkind.nvim", module = true }, -- adds vscode-like pictograms to built-in lsp
    { "hrsh7th/cmp-nvim-lsp", module = true },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", module = true },
    { "hrsh7th/cmp-nvim-lsp-signature-help", module = true },
    { "ray-x/cmp-treesitter", module = true },
    { "hrsh7th/cmp-path", module = true },
    { "hrsh7th/cmp-buffer", module = true },
    { "hrsh7th/cmp-cmdline", module = true },
    { "hrsh7th/cmp-nvim-lua", module = true },
    { "saadparwaiz1/cmp_luasnip", module = true },
    -- { "hrsh7th/cmp-omni", module = true },
    { "hrsh7th/cmp-emoji", module = true },
    -- { "petertriho/cmp-git", module = true },
    -- {
    --   "quangnguyen30192/cmp-nvim-ultisnips",
    --   module = true,
    --   dependencies = { "sirver/ultisnips" },
    -- },
  },
  opts = function()
    local nvim_web_devicons = require("nvim-web-devicons")
    local cmp = require("cmp")

    local opts = {
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          require("luasnip").lsp_exapnd(args.body)
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end,
        ["<C-p>"] = function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end,
        -- ["<C-e>"] = cmp.mapping.abort(),
      }),
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      sources = cmp.config.sources({
        { name = "ultisnips" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        -- { name = "nvim_lsp_document_symbol" },
        { name = "nvim_lsp_signature_help" },
        { name = "treesitter" },
        -- { name = "omni" },
        { name = "path" },
        { name = "nvim_lua" },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              -- use all visible buffers
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
        { name = "emoji" },
        -- { name = "git" },
      }),
      -- completion = {
      --   autocomplete = { cmp.TriggerEvent.TextChanged }
      -- },

      formatting = {
        format = function(entry, vim_item)
          if vim_item.kind == "File" then
            vim_item.abbr = nvim_web_devicons.get_icon(vim_item.word, nil, { default = true }) .. " " .. vim_item.abbr
            vim_item.kind = entry.source.name
          elseif vim_item.kind == "Folder" then
            vim_item.abbr = icons[vim_item.kind] .. " " .. vim_item.abbr
            vim_item.kind = entry.source.name
          elseif entry.source.name == "nvim_lsp" then
            vim_item.kind = icons[vim_item.kind] .. " " .. vim_item.kind
          elseif vim_item.kind == "Text" then
            vim_item.kind = icons.Text .. " " .. entry.source.name
          elseif vim_item.kind == "Snippet" then
            vim_item.kind = icons[vim_item.kind] .. " " .. entry.source.name
          elseif entry.source.name == "cmdline" then
            vim_item.kind = "cmdline"
            -- local icon = nvim_web_devicons.get_icon(vim_item.word, nil, { default = false })
            -- if icon then
            --   vim_item.abbr = icon .. " " .. vim_item.abbr
            -- end
          else
            vim_item.kind = icons[vim_item.kind] .. " " .. vim_item.kind .. " [" .. entry.source.name .. "]"
          end

          return vim_item
        end,
      },
    }

    return opts
  end,
  config = function(_, opts)
    local cmp = require("cmp")
    cmp.setup(opts)

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline({ "/", "?" }, {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = { { name = "buffer" } },
    -- })

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" },
        { name = "buffer" },
      }),
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = "path" }, { name = "cmdline" } }),
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
        { name = "buffer" },
      }),
    })
  end,
}
