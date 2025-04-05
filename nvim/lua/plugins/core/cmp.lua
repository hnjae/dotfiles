---@class myCmpOpts: cmp.ConfigSchema
---@field cmdline_search_sources cmp.SourceConfig[]

---@type LazySpec
return {
  [1] = "hrsh7th/nvim-cmp",
  lazy = false,
  enabled = true,
  cond = not vim.g.vscode and false,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "onsails/lspkind.nvim",
    -- { [1] = "hrsh7th/cmp-path" },
    { [1] = "https://codeberg.org/FelipeLema/cmp-async-path" },
    { [1] = "hrsh7th/cmp-cmdline" },
    -- { [1] = "hrsh7th/cmp-omni" },
  },
  ---@param opts myCmpOpts
  opts = function(_, opts)
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local globals = require("globals")

    -- opts.performance = {
    --   max_view_entries = 1,
    -- }

    -- opts.window = {
    --   documentation = {
    --     max_height = 2,
    --   },
    -- }

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
        [globals.map_keyword.hover_scroll_up] = cmp.mapping.scroll_docs(-4),
        [globals.map_keyword.hover_scroll_down] = cmp.mapping.scroll_docs(4),
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

    ----------------------------------------------------------------------------
    -- Sources
    ----------------------------------------------------------------------------
    opts.sources = vim.list_extend(
      opts.sources or {},
      cmp.config.sources({
        { name = "async_path" },
      })
    )

    ----------------------------------------------------------------------------
    -- formatting
    ----------------------------------------------------------------------------
    -- NOTE: cmp formatting: https://github.com/hrsh7th/nvim-cmp/issues/511#issuecomment-1063014008 <2024-05-01>
    -- vim_item.dup 프로퍼티로 duplicate 부분 제어가 가능한 것 같다.

    opts.formatting = opts.formatting or {}

    opts.formatting.fields = {
      cmp.ItemField.Abbr,
      cmp.ItemField.Kind,
      cmp.ItemField.Menu,
      cmp.ItemField.soure,
    }

    local use_icons = require("utils").use_icons
    local format_menu = {
      --key: cmp.Entry.source's name
      treesitter = "[TS]",
      path = "[Path]",
      async_path = "[Path]",
      -- lsps
      nvim_lsp = "[LSP]",
      nvim_lsp_document_symbol = "[LSP-SYMBOL]",
      nvim_lsp_signature_help = "[SIGNATURE]",
      nvim_lua = "[NVIM-LUA]",
    }

    local source_icon_map = {
      snippy = (lspkind.symbol_map["Snippet"] or " "),
      luasnip = (lspkind.symbol_map["Snippet"] or " "),
      cmdline = "", -- nf-oct-command_palette
      -- buffer = "", -- nf-cod-file_code
      -- buffer = "", -- nf-cod-text_size
      buffer = "", -- nf-fa-buffer
      emoji = "󰞅", -- nf-md-sticker_emoji
    }
    local source_out_map = {
      snippy = "Snippet",
      luasnip = "Snippet",
      cmdline = "Cmdline",
      buffer = "Buffer",
      emoji = "Emoji",
    }

    if not use_icons then
      opts.formatting.format = function(entry, vim_item)
        if source_icon_map[entry.source.name] then
          vim_item.kind = (source_out_map[entry.source.name] or "")
        else
          vim_item.menu = (
            format_menu[entry.source.name]
            or string.format("[%s]", entry.source.name)
          ) .. (vim_item.menu or "")
        end
        return vim_item
      end
    else
      opts.formatting.format = function(entry, vim_item)
        if source_icon_map[entry.source.name] then
          vim_item.kind = string.format(
            "%s %s",
            source_icon_map[entry.source.name],
            (source_out_map[entry.source.name] or "")
          )
        else
          vim_item.menu = (
            format_menu[entry.source.name]
            or string.format("[%s]", entry.source.name)
          ) .. (vim_item.menu or "")

          vim_item.kind = string.format(
            "%s %s",
            (lspkind.symbol_map[vim_item.kind] or " "),
            vim_item.kind
          )
        end

        return vim_item
      end
    end
  end,
  config = function(_, opts)
    local cmp = require("cmp")
    -- cmp.register_source("month", require("cmp_month.source"))
    cmp.setup(opts)

    -- (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = opts.cmdline_search_sources,
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    -- NOTE:  이 것 때문이지 vim-select 한게 날라간다. <2024-12-26>
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "async_path" },
        { name = "cmdline" },
        -- { name = "nvim_lsp" },
        -- { name = "nvim_lua" },
      }),
    })
  end,
  specs = {},
}
-- vim:foldmethod=marker:foldenable:foldlevel=1:
