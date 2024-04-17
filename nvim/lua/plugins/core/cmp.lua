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
    { [1] = "hrsh7th/cmp-path" },
    { [1] = "hrsh7th/cmp-buffer" },
    { [1] = "hrsh7th/cmp-cmdline" },
    -- { [1] = "hrsh7th/cmp-omni" },
    { [1] = "hrsh7th/cmp-emoji" },
  },
  opts = function(_, opts)
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local ret = {}

    opts.sorting = vim.tbl_extend("keep", {
      priority_weight = 0, -- default 2
      --[[  NOTE:  <2024-04-10>
          -- priority 계산법
          local priority = s:get_source_config().priority or ((#source_group - (i - 1)) * config.get().sorting.priority_weight)

          e.score = e.score + priority
        ]]
    }, opts.sorting or {})

    opts.mapping = vim.tbl_extend(
      "keep",
      cmp.mapping.preset.insert({
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
      opts.mapping or {}
    )

    if not opts.sources then
      opts.sources = {}
    end

    vim.list_extend(
      opts.sources,
      cmp.config.sources({
        { name = "nvim_lsp", priority = 10 },
        {
          name = "buffer",
          priority = 0,
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
      })
    )

    ----------------------------------------------------------------------------
    -- {{{ formatting
    opts.formatting = {}

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

    if not enable_icon then
      opts.formatting.format = function(entry, vim_item)
        vim_item.menu = (vim_item.menu or "")
          .. (
            format_menu[entry.source.name]
            or string.format("[%s]", entry.source.name)
          )
        return vim_item
      end
    else
      opts.formatting.format = function(entry, vim_item)
        vim_item.menu = (vim_item.menu or "")
          .. (
            format_menu[entry.source.name]
            or string.format("[%s]", entry.source.name)
          )

        vim_item.kind = string.format(
          " %s %s",
          (lspkind.symbol_map[vim_item.kind] or " "),
          vim_item.kind
        )

        return vim_item
      end
    end
    -- }}}
    ----------------------------------------------------------------------------
  end,
  config = function(_, opts)
    local cmp = require("cmp")
    -- cmp.register_source("month", require("cmp_month.source"))
    cmp.setup(opts)

    -- (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" }, -- @+typing
        { name = "treesitter" },
        { name = "buffer" },
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
  end,
}
-- vim:foldmethod=marker:foldenable:foldlevel=1:
