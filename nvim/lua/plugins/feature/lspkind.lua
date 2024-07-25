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

    local generic_icons = {
      --------------------------------------------------------------------------
      -- generic_icons for treesitter
      --------------------------------------------------------------------------
      comment = "", -- nf-cod-comment
      comment_unresolved = "", -- nf-cod-comment_unresolved
      markdown = "", -- nf-cod-markdown
      quote = "", -- nf-cod-quote
      link = "", -- nf-cod-link
      tags = "", -- nf-cod-tags
      spellcheck = "󰓆", -- nf-md-spellcheck
      label = "󰌖", -- nf-md-label_outline
      list = "", -- nf-cod-list_unordered
      misc = "",
    }

    local icons = {
      --------------------------------------------------------------------------
      -- copy & paste of lspkind's codicons
      --------------------------------------------------------------------------
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

      --------------------------------------------------------------------------
      -- Overrides defaults
      --------------------------------------------------------------------------
      Function = "󰊕", -- nf-md-function
      Snippet = "", -- nf-cod-code
      Folder = "", -- nf-cod-folder
      --  nf-cod-primitive_square
      --  nf-cod-archive
      --  nf-cod-globe
      --  nf-cod-heart
      --  nf-cod-layout

      --------------------------------------------------------------------------
      -- for Outline.nvim & lspsaga.nvim
      -- see `outline.nvim/lua/outline/symbols.lua`
      --------------------------------------------------------------------------
      File = "", -- nf-cod-file
      Object = "", -- nf-cod-circle
      Boolean = "", -- nf-cod-symbol_boolean
      Array = "", -- nf-cod-symbol-array
      Number = "", -- nf-cod_symbol_numeric
      String = "", -- nf-cod-symbol_string,
      Namespace = "", -- nf-cod-symbol_namespace
      Package = "", -- nf-cod-package
      Key = "", -- nf-cod-key
      Null = "", -- nf-cod-circle_slash
      Component = "󰩦", -- nf-md-puzzle_outline
      Fragment = "󰩦", -- nf-md-puzzle_outline
      TypeAlias = "", -- same as TypeParameter
      Parameter = "", -- same as type parameter
      StaticMethod = "", -- same as method
      Macro = "", -- nf-cod-mention
    }

    return {
      preset = "codicons",
      -- preset = "default",

      symbol_map = vim.tbl_extend("keep", icons, {
        -- treesitter
        -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md

        -- identifier
        VariableParameter = icons.Parameter,
        VariableParameterBuiltin = icons.Parameter,
        VariableBuiltin = icons.Field,
        VariableMember = icons.Field,
        ConstantBuiltin = icons.Constant,
        ConstantMacro = icons.Constant,
        ModuleBuiltin = icons.Module,
        Label = "󰌖", -- nf-md-label_outline

        -- types
        Type = icons.TypeParameter,
        TypeBuiltin = icons.TypeParameter,
        TypeDefinition = icons.TypeParameter,

        -- stylua: ignore start
        -- Functions
        FunctionBuiltin = icons.Function,
        FunctionCall    = icons.Function,
        FunctionMacro   = icons.Macro,
        FunctionMethod     = icons.Method,
        FunctionMethodCall = icons.Method,

        -- Keywords
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

        -- punctuation
        PunctuationSpecial   = generic_icons.quote,
        PunctuationBracket   = generic_icons.quote,
        PunctuationDelimiter = generic_icons.quote,

        -- Comments
        Comment              = generic_icons.comment,
        CommentDocumentation = generic_icons.comment,
        CommentNote          = generic_icons.comment,
        CommentError         = generic_icons.comment_unresolved,
        CommentWarning       = generic_icons.comment_unresolved,
        CommentTodo          = generic_icons.comment_unresolved,

        -- Markup
        MarkupHeading  = generic_icons.markdown,
        MarkupHeading1 = generic_icons.markdown,
        MarkupHeading2 = generic_icons.markdown,
        MarkupHeading3 = generic_icons.markdown,
        MarkupHeading4 = generic_icons.markdown,
        MarkupHeading5 = generic_icons.markdown,
        MarkupHeading6 = generic_icons.markdown,

        MarkupLink      = generic_icons.link,
        MarkupLinkUrl   = generic_icons.link,
        MarkupLinkLabel = generic_icons.label,

        MarkupList          = generic_icons.markdown,
        MarkupListChecked   = generic_icons.markdown,
        MarkupListUnchecked = generic_icons.markdown,
        MarkupRaw      = generic_icons.markdown,
        MarkupRawBlock = generic_icons.markdown,
        MarkupQuote = generic_icons.quote,
        MarkupMath = generic_icons.markdown,

        -- diff
        DiffPlus  = "", -- nf-cod-diff_added
        DiffMinus = "", -- nf-cod-diff_removed
        DiffDelta = "", -- nf-cod-diff_modified

        -- tag
        Tag          = generic_icons.tags,
        TagBuiltin   = icons.Method,
        TagAttribute = icons.Property,
        TagDelimiter = icons.Keyword,

        StringSpecial = icons.String,
        StringSpecialUrl = icons.String,
        StringSpecialPath = "", -- nf-oct-rel_file_path

        Spell   = generic_icons.spellcheck,
        Nospell = generic_icons.spellcheck,
        -- stylua: ignore end

        None = icons.Null,
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
