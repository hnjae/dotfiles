---@type LazySpec
return {
  [1] = "dcampos/nvim-snippy",
  lazy = true,
  enabled = true,
  event = { "InsertEnter" },
  ft = {
    "snippets",
  },
  opts = function()
    return {
      snippet_dirs = require("plenary.path"):new(
        vim.fn.stdpath("config"),
        "snippets"
      ).filename,
    }
  end,
  ---@type fun(LazyPlugin, opts: table): LazyKeysSpec[]
  keys = function()
    local snippy = require("snippy")
    return {
      -- NOTE: cmp 에서 관리 <2024-03-11>
      -- {
      --   [1] = "<Tab>",
      --   [2] = function()
      --     return snippy.can_expand_or_advance()
      --         and "<Plug>(snippy-expand-or-advance)"
      --       or "<Tab>"
      --   end,
      --   mode = "i",
      --   desc = "snippy-expand-or-advance",
      --   expr = true,
      -- },
      -- {
      --   [1] = "<S-Tab>",
      --   [2] = function()
      --     return snippy.can_jump(-1) and "<plug>(snippy-previous)" or "<S-Tab>"
      --   end,
      --   mode = "i",
      --   desc = "snippy-previous",
      --   expr = true,
      -- },
      {
        [1] = "<Tab>",
        [2] = function()
          snippy.next("<Tab>")
        end,
        mode = "n",
        desc = "snippy-next-or-tab",
      },
      {
        [1] = "<S-Tab>",
        [2] = function()
          snippy.previous("<S-Tab>")
        end,
        mode = "n",
        desc = "snippy-previous-or-s-tab",
      },
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
}
