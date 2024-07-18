-- snippet plugin

---@type LazySpec
return {
  [1] = "dcampos/nvim-snippy",
  lazy = true,
  enabled = true,
  event = { "InsertEnter" },
  cmd = {
    "SnippyEdit",
    "SnippyReload",
  },
  ft = {
    "snippets",
  },
  opts = function(_, opts)
    opts.snippet_dirs = require("plenary.path"):new(
      vim.fn.stdpath("config"),
      "assets",
      "snippets"
    ).filename

    opts.virtual_markers = {
      enabled = vim.fn.has("nvim-0.10") == 1,
    }
  end,
  ---@type fun(LazyPlugin, opts: table): LazyKeysSpec[]
  keys = function()
    local snippy = require("snippy")
    return {
        -- stylua: ignore start
        { [1] = "<Tab>",   [2] = function() snippy.next("<Tab>") end,       mode = "n", desc = "snippy-next-or-tab" },
        { [1] = "<S-Tab>", [2] = function() snippy.previous("<S-Tab>") end, mode = "n", desc = "snippy-previous-or-s-tab" },
      -- stylua: ignore end

      {
        [1] = "<Tab>",
        [2] = "<Plug>(snippy-cut-text)",
        mode = "x",
        desc = "snippy-cut-text",
      },
      {
        [1] = "g<Tab>",
        [2] = "<Plug>(snippy-cut-text)",
        mode = "n",
        desc = "snippy-cut-text (operator)",
      },
      {
        [1] = "<Leader>R",
        [2] = "<cmd>SnippyReload<cr>",
        mode = "n",
        desc = "snippy-reload",
      },
    }
  end,
  config = function(_, opts)
    require("snippy").setup(opts)
  end,
  specs = {
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = {
        {
          [1] = "dcampos/cmp-snippy",
          dependencies = { "dcampos/nvim-snippy" },
        },
      },
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        local snippy = require("snippy")
        local cmp = require("cmp")

        if not opts.sources then
          opts.sources = {}
        end

        if not opts.mapping then
          opts.mapping = {}
        end

        opts.snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            snippy.expand_snippet(args.body)
          end,
        }

        opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.get_active_entry() then
            cmp.confirm()
          elseif snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
          else
            fallback()
          end
        end, { "i", "s" }) -- normal mode does not works here <2024-04-02>
        opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
          if snippy.can_jump(-1) then
            snippy.previous()
          else
            fallback()
          end
        end, { "i", "s" })

        table.insert(
          opts.sources,
          1,
          { name = "snippy", group_index = 1, priority = 10 }
        )

        return opts
      end,
    },
  },
}
