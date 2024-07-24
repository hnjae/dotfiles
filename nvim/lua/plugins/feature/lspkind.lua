---@type LazySpec
return {
  -- adds vscode-like pictograms to built-in lsp
  [1] = "onsails/lspkind.nvim",
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
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
        Field = "",
        -- Variable = "",
        -- Class = "",
        -- Interface = "",
        Module = "",
        Property = "",
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
        Constant = "",
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

        Conceal = icons.Keyword,

        --
        File = "", -- nf-cod-file
        Folder = "", -- nf-cod-folder
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
        Macro = "", -- nf-cod-mention
        Null = "", -- nf-cod-circle_slash

        --
        Misc = "",
      }
    end

    return {
      preset = "codicons",
      -- preset = "default",
      symbol_map = vim.tbl_extend("keep", icons, {
        -- treesitter
        -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md

        -- {{{ identifier
        VariableParameter = icons.Parameter,
        VariableParameterBuiltin = icons.Parameter,
        VariableBuiltin = icons.Field,
        VariableMember = icons.Field,

        ConstantBuiltin = icons.Constant,
        ConstantMacro = icons.Constant,

        ModuleBuiltin = icons.Module,

        Label = "󰌖", -- nf-md-label_outline
        -- }}}

        -- {{{ types
        Type = icons.TypeParameter,
        TypeBuiltin = icons.TypeParameter,
        TypeDefinition = icons.TypeParameter,
        -- }}}

        -- stylua: ignore start
        -- {{{ Functions
        FunctionBuiltin = icons.Function,
        FunctionCall    = icons.Function,

        FunctionMacro = icons.Macro,

        FunctionMethod     = icons.Method,
        FunctionMethodCall = icons.Method,
        -- }}}

        -- {{{ Keywords
        KeywordCoroutine = icons.Keyword,
        KeywordFunction  = icons.Keyword,
        KeywordOperator  = icons.Keyword,
        KeywordImport    = icons.Keyword,
        KeywordType      = icons.Keyword,
        KeywordModifier  = icons.Keyword,
        KeywordRepeat    = icons.Keyword,
        KeywordReturn    = icons.Keyword,
        KeywordDebug     = icons.Keyword,
        KeywordException = icons.Keyword,

        KeywordConditional        = icons.Keyword,
        KeywordConditionalTernary = icons.Keyword,

        KeywordDirective       = icons.Keyword,
        KeywordDirectiveDefine = icons.Keyword,
        -- }}}

        -- {{{ punctuation
        PunctuationSpecial   = "", -- nf-cod-quote
        PunctuationBracket   = "", -- nf-cod-quote
        PunctuationDelimiter = "", -- nf-cod-quote
        -- }}}

        -- {{{ Comments
        Comment              = "", -- nf-cod-comment
        CommentDocumentation = "", -- nf-cod-comment
        CommentError         = "", -- nf-cod-comment
        CommentWarning       = "", -- nf-cod-comment
        CommentTodo          = "", -- nf-cod-comment
        CommentNote          = "", -- nf-cod-comment
        -- }}}
        -- {{{ Markup
        MarkupHeading  = "", -- nf-cod-markdown
        MarkupHeading1 = "", -- nf-cod-markdown
        MarkupHeading2 = "", -- nf-cod-markdown
        MarkupHeading3 = "", -- nf-cod-markdown
        MarkupHeading4 = "", -- nf-cod-markdown
        MarkupHeading5 = "", -- nf-cod-markdown
        MarkupHeading6 = "", -- nf-cod-markdown

        MarkupLink      = "", -- nf-cod-link
        MarkupLinkLabel = "󰌖", -- nf-md-label_outline
        MarkupLinkUrl   = "", -- nf-cod-link

        MarkupList          = "", -- nf-cod-markdown
        MarkupListChecked   = "", -- nf-cod-markdown
        MarkupListUnchecked = "", -- nf-cod-markdown

        MarkupRaw      = "", -- nf-cod-markdown
        MarkupRawBlock = "", -- nf-cod-markdown

        MarkupQuote = "", -- nf-cod-quote

        MarkupMath = "", -- nf-cod-markdown
        -- }}}

        -- {{{ diff
        DiffPlus  = "", -- nf-cod-diff_added
        DiffMinus = "", -- nf-cod-diff_removed
        DiffDelta = "", -- nf-cod-diff_modified
        -- }}}

        -- {{{ tag
        Tag          = "", -- nf-cod-tags
        TagBuiltin   = icons.Method,
        TagAttribute = icons.Property,
        TagDelimiter = icons.Keyword,
        -- }}}

        StringSpecialUrl = icons.String,
        StringSpecialPath = "", -- nf-oct-rel_file_path
        -- stylua: ignore end

        None = icons.Null,
        Spell = "󰓆", -- nf-md-spellcheck

        -- Outline.nvim
        StaticMethod = icons.method,
        -- Component = "",
        -- Fragment = "",
      }),
    }
  end,
  config = function(_, opts)
    local lspkind = require("lspkind")
    lspkind.init(opts)
  end,
}
