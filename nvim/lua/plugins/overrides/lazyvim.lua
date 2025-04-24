local icons = require("globals").icons
---@type LazySpec
return {
  [1] = "LazyVim",
  optional = true,
  opts = {
    icons = {
      diagnostics = {
        -- Error = " ", -- nf-cod-error
        -- Warn = " ", -- nf-cod-warning
        -- Info = " ", -- nf-cod-info
        -- Hint = " ", -- nf-cod-question
        Error = icons.severity.error,
        Warn = icons.severity.warn,
        Info = icons.severity.info,
        Hint = icons.severity.hint,
      },
      git = {
        added = " ", -- nf-cod-diff_added
        modified = " ", -- nf-cod-diff_modified
        removed = " ", -- nf-cod-diff_renamed
      },
      kinds = {
        ---------------------------------------------
        -- from lazyvim
        ---------------------------------------------
        -- Codeium = "󰘦 ",
        -- Control = " ",
        -- Collapsed = " ",
        -- Copilot = " ",

        ---------------------------------------------
        -- from codicons
        ---------------------------------------------
        -- Operator = " ",
        Array = " ", -- nf-cod-symbol-array
        Boolean = " ", -- nf-cod-symbol_boolean
        Class = " ",
        Color = " ",
        Enum = " ", -- nf-cod-symbol_enum
        EnumMember = " ", -- nf-cod-symbol_enum_member
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Interface = " ",
        Key = " ", -- nf-cod-key
        Keyword = " ",
        Method = " ", -- nf-cod-symbol_method
        Namespace = " ", -- nf-cod-symbol_namespace
        Number = " ", -- nf-cod_symbol_numeric
        Package = " ", -- nf-cod-package
        -- Property = " ", -- nf-cod-symbol_property
        Reference = " ", -- nf-cod-references
        String = " ", -- nf-cod-symbol_string,
        Struct = " ",
        TypeParameter = " ", -- nf-cod-symbol_parameter
        Unit = " ",
        Variable = " ",
        -- Constant = " ", -- nf-cod-symbol_constant
        Snippet = " ", -- nf-cod-symbol_snippet

        ---------------------------------------------
        -- MY OVERRIDES & ADDS
        ---------------------------------------------
        -- Module = "󰆧 ", -- nf-md-cube_outline
        -- Module = "󰮄 ", -- nf-md-cube_scan
        Property = "󰓼 ", -- nf-md-tag_outline
        -- Property = " ", -- nf-cod-tag
        Constant = "󰏿 ", -- nf-md-pi
        Constructor = " ", -- nf-cod-gear
        Function = "󰊕 ", -- nf-md-function
        Macro = " ", -- nf-cod-mention
        Module = "󱃖 ", -- nf-md-code_braces-box
        Null = " ", -- nf-cod-circle_slash
        Object = " ", -- nf-cod-circle
        -- Object = " ", -- nf-cod-bracket_dot
        -- Object = " ", -- nf-cod-symbol_namespace
        Operator = "󰆕 ", -- nf-md-contrast
        Text = " ", -- nf-cod-symbol_key
        -- Collapsed = " ", -- nf-cod-fold
      },
    },
  },
}
