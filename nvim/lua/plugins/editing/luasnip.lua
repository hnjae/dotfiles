---@type LazySpec
return {
  [1] = "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  enabled = vim.fn.executable("make") == 1,
  -- enabled = true,
  lazy = false,
  event = { "InsertEnter" },
  dependencies = {
    "nvim-lua/plenary.nvim", -- used in config function
  },
  opts = {
    store_selection_keys = "<Tab>",
  },
  ---@type fun(LazyPlugin, keys: string[]): LazyKeysSpec[]
  keys = function(_, keys)
    local luasnip = require("luasnip")
    return vim.list_extend(keys, {
      {
        [1] = "<Leader>S",
        [2] = "<cmd>SnipEdit<CR>",
        desc = "snippet-edit",
      },
      {
        [1] = "<Tab>",
        [2] = function()
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          end
        end,
        mode = "n",
        desc = "luasnip-next",
      },
      {
        [1] = "<S-Tab>",
        [2] = function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end,
        mode = "n",
        desc = "luasnip-previous",
      },
    })
  end,
  cmd = {
    "SnipEdit",
  },
  config = function(_, opts)
    require("luasnip").setup(opts)
    local Path = require("plenary.path")

    -- local snippet_path = Path:new( vim.fn.resolve( Path:new(vim.fn.stdpath("config"), "assets", "snippets").filename))
    local snippet_path =
      Path:new(vim.fn.stdpath("config"), "assets", "snippets")

    require("luasnip.loaders.from_snipmate").lazy_load({
      ---@diagnostic disable-next-line: assign-type-mismatch
      paths = snippet_path.filename,
    })

    vim.api.nvim_create_user_command("SnipEdit", function()
      require("luasnip.loaders").edit_snippet_files({
        ---@param file string
        edit = function(file)
          vim.api.nvim_command("split " .. file)
        end,
        format = function(file, _)
          return vim.fn.fnamemodify(file, ":t")
        end,
      })
    end, {})
  end,
  specs = {
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = {
        { [1] = "saadparwaiz1/cmp_luasnip" },
      },
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        opts.snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        }

        if not opts.mapping then
          opts.mapping = {}
        end
        opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.get_active_entry() then
            cmp.confirm()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" })
        opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" })

        opts.sources = vim.list_extend(
          { { name = "luasnip", group_index = 1, priority = 10 } },
          opts.sources or {}
        )
      end,
    },
    {
      [1] = "danymat/neogen",
      optional = true,
      opts = {
        snippet_engine = "luasnip",
      },
    },
  },
}
