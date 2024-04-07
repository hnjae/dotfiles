---@type LazySpec
return {
  -- adds vscode-like pictograms to built-in lsp
  [1] = "onsails/lspkind.nvim",
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    -- local devicons = require("nvim-web-devicons")
    -- local val = require("val")
    local utils = require("utils")

    local icons = {}
    if utils.is_plugin("lspsaga.nvim") then
      icons.Keyword = ""
      for _, value in pairs(require("lspsaga.lspkind").kind) do
        icons[value[1]] = value[2]:sub(1, #value[2] - 1)
      end
    else
      icons = {
        -- based on lspkind's codicons
        -- Text = "",
        Method = "",
        -- Function = "",
        -- Constructor = "",
        -- Field = "",
        -- Variable = "",
        -- Class = "",
        -- Interface = "",
        -- Module = "",
        -- Property = "",
        -- Unit = "",
        -- Value = "",
        -- Enum = "",
        Keyword = "",
        -- Snippet = "",
        -- Color = "",
        -- File = "",
        -- Reference = "",
        -- Folder = "",
        -- EnumMember = "",
        -- Constant = "",
        -- Struct = "",
        -- Event = "",
        -- Operator = "",
        TypeParameter = "",

        -- Overrides
        Function = "󰊕", -- nf-md-function
        --  nf-cod-primitive_square
        --  nf-cod-archive
        --  nf-cod-globe
        --  nf-cod-heart
        --  nf-cod-layout

        --
        File = "", -- nf-cod-file
        Folder = "", -- nf-cod-folder
        Misc = "",
        -- for Outline.nvim
        Object = "", -- nf-cod-circle
        Boolean = "", -- nf-cod-symbol_boolean
        Array = "", -- nf-cod-symbol-array
        Number = "", -- nf-cod_symbol_numeric
        String = "", -- nf-cod-symbol_string,
        Namespace = "", -- nf-cod-symbol_namespace
        Package = "", -- nf-cod-package
        TypeAlias = "", -- nf-cod-link
        Parameter = "",
        Key = "", -- nf-cod-key
        -- Macro = "", -- nf-cod-mention
        Null = "", -- nf-cod-circle_slash
      }
    end

    return {
      preset = "codicons",
      -- preset = "default",
      symbol_map = vim.tbl_extend("force", icons, {
        -- treesitter
        Type = icons.TypeParameter,
        FunctionCall = icons.Function,
        Comment = "", -- nf-cod-comment
        KeywordConditional = icons.Keyword,
        KeywordRepeat = icons.Keyword,
        KeywordFunction = icons.Keyword,
        KeywordDirective = icons.Keyword,
        KeywordReturn = icons.Keyword,
        Label = "󰌖", -- nf-md-label_outline
        None = icons.Null,
        PunctuationSpecial = "", -- nf-cod-quote
        VariableParameter = icons.Parameter,
        MarkupLink = "", -- nf-cod-link
        MarkupRaw = "", -- nf-cod-markdown
        MarkupRawBlock = "", -- nf-cod-markdown
        MarkupHeading1 = "", -- nf-cod-markdown
        MarkupHeading2 = "", -- nf-cod-markdown
        MarkupHeading3 = "", -- nf-cod-markdown
        MarkupHeading4 = "", -- nf-cod-markdown

        -- Outline.nvim
        StaticMethod = icons.method,
        Component = "",
        Fragment = "",
      }),
    }
  end,
  config = function(_, opts)
    local lspkind = require("lspkind")
    lspkind.init(opts)
  end,
}
