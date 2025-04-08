-- LazyExtra's coding.luasnip

---@type LazySpec
return {
  [1] = "LuaSnip",
  optional = true,
  opts = {
    store_selection_keys = "<Tab>",
  },
  cmd = {
    "EditSnippet",
    "LuaSnipListAvailable",
    "LuaSnipUnlinkCurrent",
  },
  ---@type fun(LazyPlugin, keys: string[]): LazyKeysSpec[]
  keys = function(_, keys)
    local luasnip = require("luasnip")

    return vim.list_extend(keys, {
      {
        [1] = "<Tab>",
        mode = "n",
        [2] = function()
          if luasnip.locally_jumpable(1) then
            return "<Plug>luasnip-jump-next"
          end

          return "<Tab>"
        end,
        expr = true,
        desc = "luasnip-next",
      },
      {
        [1] = "<S-Tab>",
        mode = "n",
        [2] = function()
          if luasnip.locally_jumpable(-1) then
            return "<Plug>luasnip-jump-prev"
          end

          return "<S-Tab>"
        end,
        expr = true,
        desc = "luasnip-previous",
      },

      {
        -- ipe
        [1] = "<Leader>sp",
        mode = "n",
        [2] = "<cmd>LuaSnipListAvailable<CR>",
        desc = "Snippets (Luasnip)",
      },
      -- {
      --   [1] = "<Leader>sP",
      --   mode = "n",
      --   [2] = "<cmd>EditSnippet<CR>",
      --   desc = "edit-snippet (Luasnip)",
      -- },
    })
  end,
  config = function(_, opts)
    local luasnip = require("luasnip")
    luasnip.setup(opts)

    vim.api.nvim_create_user_command("EditSnippet", function()
      require("luasnip.loaders").edit_snippet_files({
        ---@param file string
        edit = function(file)
          vim.api.nvim_command("vsplit " .. file)
        end,
        format = function(file, _)
          return vim.fn.fnamemodify(file, ":t")
        end,
      })
    end, {})

    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
    })
  end,
  specs = {
    -- disable friendly-snippets
    { [1] = "friendly-snippets", optional = true, enabled = false },
    {
      [1] = "which-key.nvim",
      optional = true,
      ---@type wk.Opts
      opts = {
        icons = {
          rules = {
            {
              plugin = "LuaSnip",
              icon = "", -- nf-cod-symbol_snippet
              color = "green", -- in gruvbox.nvim, BlinkCmpKindSnippet is linked to green <2025-04-09>
            },
          },
        },
      },
    },
  },
}
