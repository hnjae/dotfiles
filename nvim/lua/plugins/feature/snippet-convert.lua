-- NOTE: snippet-converter does not support jsonc file type <2024-02-03>
-- - **vsnip**: a superset of VSCode snippets (vsnip snippets can contain Vimscript
--     code)
-- - **UltiSnips**
-- - **SnipMate**
-- - **YASnippet** (an Emacs snippet engine)

---@type LazySpec
return {
  [1] = "smjonas/snippet-converter.nvim",
  enabled = true,
  cmd = {
    "ConvertSnippets",
  },
  config = function(_, _)
    local t1 = {
      name = "from_vscode_to_ultisnips",
      sources = {
        vscode_luasnip = {
          "path",
        },
      },
      output = {
        ultisnips = {
          "path",
        },
      },
    }

    local t2 = {
      name = "from_ultisnips_to_snipmate",
      sources = {
        ultisnips = {
          "path",
        },
      },
      output = {
        snipmate = {
          "path",
        },
      },
    }

    local t3 = {
      name = "from_vscode_to_snipmate",
      sources = {
        vscode_luasnip = {
          "path",
        },
      },
      output = {
        snipmate = {
          "path",
        },
      },
    }
    -- code
    require("snippet_converter").setup({
      templates = {
        t3,
      },
    })
  end,
  opts = {},
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          snippet_converter = {
            display_name = "Snippet Converter",
            icon = icons.zap,
          },
        })
      end,
    },
  },
}
