-- LazyExtra's coding.luasnip

---@type LazySpec
return {
  [1] = "LuaSnip",
  optional = true,
  opts = {
    store_selection_keys = "<Tab>",
  },
  dependencies = {
    {
      -- disable friendly-snippets
      "friendly-snippets",
      optional = true,
      enabled = false,
    },
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
        [1] = "<Leader>sp",
        mode = "n",
        [2] = "<cmd>LuaSnipListAvailable<CR>",
        desc = "Snippets (Luasnip)",
      },
      {
        [1] = "<Leader>sP",
        mode = "n",
        [2] = "<cmd>EditSnippet<CR>",
        desc = "edit-snippet (Luasnip)",
      },
    })
  end,
  config = function(_, opts)
    local luasnip = require("luasnip")
    luasnip.setup(opts)

    vim.api.nvim_create_user_command("EditSnippet", function()
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

    require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
  end,
}
