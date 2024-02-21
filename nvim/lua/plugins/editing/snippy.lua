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
      {
        [1] = "<Tab>",
        [2] = function()
          return snippy.can_expand_or_advance()
              and "<Plug>(snippy-expand-or-advance)"
            or "<Tab>"
        end,
        mode = "i",
        desc = "snippy-expand-or-advance",
        expr = true,
      },
      {
        [1] = "<S-Tab>",
        [2] = function()
          return snippy.can_jump(-1) and "<plug>(snippy-previous)" or "<S-Tab>"
        end,
        mode = "i",
        desc = "snippy-previous",
        expr = true,
      },
      {
        [1] = "<Tab>",
        [2] = function()
          return snippy.can_jump(1) and "<plug>(snippy-next)" or "<Tab>"
        end,
        mode = "s",
        desc = "snippy-next",
        expr = true,
      },
      {
        [1] = "<S-Tab>",
        [2] = function()
          return snippy.can_jump(-1) and "<plug>(snippy-previous)" or "<S-Tab>"
        end,
        mode = "s",
        desc = "snippy-previous",
        expr = true,
      },
      {
        [1] = "<Tab>",
        [2] = "<Plug>(snippy-cut-text)",
        mode = "x",
        desc = "snippy-cut-text",
      },
    }
  end,
  config = function(_, opts)
    require("snippy").setup(opts)
    -- vim.cmd([[
    --     imap <expr> <Tab> snippy#can_expand_or_advance() ? '<Plug>(snippy-expand-or-advance)' : '<Tab>'
    --     imap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
    --     smap <expr> <Tab> snippy#can_jump(1) ? '<Plug>(snippy-next)' : '<Tab>'
    --     smap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
    --     xmap <Tab> <Plug>(snippy-cut-text)
    -- ]])
  end,
}
