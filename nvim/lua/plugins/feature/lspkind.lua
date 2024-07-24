---@type LazySpec
return {
  -- adds vscode-like pictograms to built-in lsp
  [1] = "onsails/lspkind.nvim",
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    -- if utils.is_plugin("lspsaga.nvim") then
    --   icons.Keyword = ""
    --   for _, value in pairs(require("lspsaga.lspkind").kind) do
    --     icons[value[1]] = value[2]:sub(1, #value[2] - 1)
    --   end
    local icons = {
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

      -- Overrides defaults
      Function = "󰊕", -- nf-md-function
      --  nf-cod-primitive_square
      --  nf-cod-archive
      --  nf-cod-globe
      --  nf-cod-heart
      --  nf-cod-layout

      --
      File = "", -- nf-cod-file
      Folder = "", -- nf-cod-folder

      -- for Outline.nvim & lspsaga.nvim
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
      -- Misc = "",
    }

    return {
      preset = "codicons",
      -- preset = "default",

      symbol_map = vim.tbl_extend("keep", icons, {
        Conceal = icons.Keyword,

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

        StringSpecial = icons.String,
        StringSpecialUrl = icons.String,
        StringSpecialPath = "", -- nf-oct-rel_file_path
        -- stylua: ignore end

        None = icons.Null,
        Spell = "󰓆", -- nf-md-spellcheck

        -- Outline.nvim
        StaticMethod = icons.Method,
        -- Component = "",
        -- Fragment = "",
      }),
    }
  end,
  config = function(_, opts)
    local lspkind = require("lspkind")
    lspkind.init(opts)
  end,
  specs = {
    {
      [1] = "nvimdev/lspsaga.nvim",
      optional = true,
      opts = function(_, opts)
        local kind = {
          -- type, icon, hlgroup(maybe)
          { "File", " ", "Tag" },
          { "Module", " ", "Exception" },
          { "Namespace", " ", "Include" },
          { "Package", " ", "Label" },
          { "Class", " ", "Include" },
          { "Method", " ", "Function" },
          { "Property", " ", "@property" },
          { "Field", " ", "@field" },
          { "Constructor", " ", "@constructor" },
          { "Enum", " ", "@number" },
          { "Interface", " ", "Type" },
          { "Function", "󰡱 ", "Function" },
          { "Variable", " ", "@variable" },
          { "Constant", " ", "Constant" },
          { "String", "󰅳 ", "String" },
          { "Number", "󰎠 ", "Number" },
          { "Boolean", " ", "Boolean" },
          { "Array", "󰅨 ", "Type" },
          { "Object", " ", "Type" },
          { "Key", " ", "Constant" },
          { "Null", "󰟢 ", "Constant" },
          { "EnumMember", " ", "Number" },
          { "Struct", " ", "Type" },
          { "Event", " ", "Constant" },
          { "Operator", " ", "Operator" },
          { "TypeParameter", " ", "Type" },
          -- ccls
          [252] = { "TypeAlias", " ", "Type" },
          [253] = { "Parameter", " ", "@parameter" },
          [254] = { "StaticMethod", " ", "Function" },
          [255] = { "Macro", " ", "Macro" },
          -- for completion sb microsoft!!!
          [300] = { "Text", "󰭷 ", "String" },
          [301] = { "Snippet", " ", "@variable" },
          [302] = { "Folder", " ", "Title" },
          [303] = { "Unit", "󰊱 ", "Number" },
          [304] = { "Value", " ", "@variable" },
          [305] = { "Spell", " ", "@variable" },
        }

        if not opts.ui then
          opts.ui = {}
        end
        if not opts.ui.kind then
          opts.ui.kind = {}
        end

        local symbol_map = require("lspkind").symbol_map
        for _, val in pairs(kind) do
          if symbol_map[val[1]] then
            opts.ui.kind[val[1]] = { symbol_map[val[1]] .. " ", val[3] }
          end
        end
      end,
    },
  },
}
