local icons = {
  Text = "",
  -- Text = "",
  -- Text = "-",
  Method = "",
  -- Function = "",
  Function = "󰊕",
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

---@type LazySpec
return {
  [1] = "hrsh7th/nvim-cmp",
  lazy = false,
  enabled = true,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    -- { "onsails/lspkind.nvim", module = true }, -- adds vscode-like pictograms to built-in lsp
    { [1] = "hrsh7th/cmp-nvim-lsp" },
    { [1] = "hrsh7th/cmp-nvim-lsp-document-symbol" },
    { [1] = "hrsh7th/cmp-nvim-lsp-signature-help" },
    { [1] = "ray-x/cmp-treesitter" },
    { [1] = "hrsh7th/cmp-path" },
    { [1] = "hrsh7th/cmp-buffer" },
    { [1] = "hrsh7th/cmp-cmdline" },
    { [1] = "hrsh7th/cmp-nvim-lua" },
    -- { "hrsh7th/cmp-omni", module = true },
    { [1] = "hrsh7th/cmp-emoji" },
    -- { "petertriho/cmp-git", module = true },
    {
      [1] = "dcampos/cmp-snippy",
      dependencies = { "dcampos/nvim-snippy" },
    },
  },
  opts = function()
    local nvim_web_devicons = require("nvim-web-devicons")
    local cmp = require("cmp")

    local opts = {
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          require("snippy").expand_snippet(args.body)
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        -- ["<F3>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
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
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp_document_symbol" },
        { name = "snippy" },
        -- { name = "omni" },
        { name = "nvim_lua" },
        { name = "treesitter" },
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
        { name = "path" },
        -- { name = "month" },
      }),
      formatting = {
        format = function(entry, vim_item)
          if vim_item.kind == "File" then
            vim_item.abbr = nvim_web_devicons.get_icon(
              vim_item.word,
              nil,
              { default = true }
            ) .. " " .. vim_item.abbr
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
          else
            vim_item.kind = vim_item.kind .. " [" .. entry.source.name .. "]"
          end

          return vim_item
        end,
      },
    }

    return opts
  end,
  config = function(_, opts)
    local cmp = require("cmp")
    -- cmp.register_source("month", require("cmp_month.source"))
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

    local is_cmp_autopairs, cmp_autopairs =
      pcall(require, "nvim-autopairs.completion.cmp")
    if is_cmp_autopairs then
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  end,
}
