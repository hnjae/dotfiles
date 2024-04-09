local val = require("val")

---@type LazySpec
return {
  [1] = "hrsh7th/nvim-cmp",
  lazy = false,
  enabled = true,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "onsails/lspkind.nvim",
    { [1] = "hrsh7th/cmp-nvim-lsp" },
    -- / (search) 에서 사용 용도 @ + typing
    { [1] = "hrsh7th/cmp-nvim-lsp-document-symbol" },
    -- displaying function signatures
    { [1] = "hrsh7th/cmp-nvim-lsp-signature-help" },
    { [1] = "ray-x/cmp-treesitter" },
    { [1] = "hrsh7th/cmp-path" },
    { [1] = "hrsh7th/cmp-buffer" },
    { [1] = "hrsh7th/cmp-cmdline" },
    { [1] = "hrsh7th/cmp-nvim-lua" }, -- auto complete neovim's Lua runtime API e.g.) vim.*
    -- { [1] = "hrsh7th/cmp-omni" },
    { [1] = "hrsh7th/cmp-emoji" },
    -- { "petertriho/cmp-git", module = true },
    {
      [1] = "dcampos/cmp-snippy",
      dependencies = { "dcampos/nvim-snippy" },
    },
  },
  opts = function()
    local cmp = require("cmp")
    local snippy = require("snippy")
    local lspkind = require("lspkind")
    local devicons = require("nvim-web-devicons")

    local ret = {
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          require("snippy").expand_snippet(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.get_active_entry() then
            cmp.confirm()
          elseif snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
          else
            fallback()
          end
        end, { "i", "s" }), -- normal mode does not works here <2024-04-02>
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if snippy.can_jump(-1) then
            snippy.previous()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        -- ["<C-S-h>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        -- ["<C-S-l>"] = cmp.mapping.scroll_docs(4),
        -- ["<F3>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-n>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end, { "i" }),
        ["<C-p>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end, { "i" }),
        -- ["<C-y>"] = cmp.mapping(function()
        --   cmp.mapping.confirm({ select = false })
        -- end, { "i" }),
        -- ["<C-e>"] = cmp.mapping(function()
        --   cmp.mapping.abort()
        -- end, { "i" }),

        -- replace omnifunc's mapping
        -- ["<C-x><C-o>"] = cmp.mapping(cmp.complete, { "i" }),
      }),
      sources = cmp.config.sources({
        -- { name = "omni" },
        -- displaying function signatures
        { name = "nvim_lsp_signature_help" },
        { name = "snippy" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "treesitter" },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              -- use all visible buffers
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if
                  vim.bo[buf].buftype == ""
                  or vim.bo[buf].buftype == "terminal"
                then
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
        { name = "emoji" },
        { name = "path" },
        -- { name = "month" },
      }),
    }

    ----------------------------------------------------------------------------
    -- formatting
    ----------------------------------------------------------------------------
    local enable_icon = require("utils").enable_icon
    local format_menu = {
      --key: cmp.Entry.source's name
      snippy = "[SNIP]",
      buffer = "[BUF]",
      treesitter = "[TS]",
      path = "[Path]",
      -- lsps
      nvim_lsp = "[LSP]",
      nvim_lsp_document_symbol = "[DOCUMENT-SYMBOL]",
      nvim_lsp_signature_help = "[SIGNATURE]",
      nvim_lua = "[NVIM_LUA]",
      --
      cmdline = "[CMDLINE]",
    }

    --   format = require("lspkind").cmp_format({
    --     mode = require("utils").enable_icon and "symbol" or "text",
    --     -- ellipsis_char = "",
    --
    --     -- key: entry.source.name
    --     menu = {
    --       nvim_lsp = "[LSP]",
    --       snippy = "[Snippy]",
    --     },
    --     show_labelDetails = true,
    --     before = function(entry, vim_item)
    --       vim_item.menu = entry.source.name .. (vim_item.menu or "")
    --       return vim_item
    --     end,
    --   }),
    ret.formatting = {
      format = function(entry, vim_item)
        vim_item.menu = (vim_item.menu or "")
          .. (
            format_menu[entry.source.name]
            or string.format("[%s]", entry.source.name)
          )

        if enable_icon then
          -- enable_icon and vim_item.kind == "File" or vim_item.kind == "Folder"
          vim_item.kind = string.format(
            " %s %s",
            (lspkind.symbol_map[vim_item.kind] or "?"),
            vim_item.kind
          )
        end

        return vim_item
      end,
    }

    return ret
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
        { name = "buffer" },
        { name = "treesitter" },
        { name = "nvim_lsp_document_symbol" }, -- @+typing
      }),
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
        -- { name = "nvim_lsp" },
        -- { name = "nvim_lua" },
      }),
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
