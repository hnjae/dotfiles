local entries = {
  "Array",
  "Boolean",
  "Class",
  "Color",
  "Control",
  "Collapsed",
  "Constant",
  "Constructor",
  "Enum",
  "EnumMember",
  "Event",
  "Field",
  "File",
  "Folder",
  "Function",
  "Interface",
  "Key",
  "Keyword",
  "Method",
  "Module",
  "Namespace",
  "Null",
  "Number",
  "Object",
  "Operator",
  "Package",
  "Property",
  "Reference",
  "Snippet",
  "String",
  "Struct",
  "Text",
  "TypeParameter",
  "Unit",
  "Value",
  "Variable",
}

---@type LazySpec[]
return {
  {
    [1] = "LazyVim",
    optional = true,
    dependencies = { "mini.icons" },
    ---@param opts LazyVimOptions
    opts = function(_, opts)
      opts.icons = opts.icons or {}
      opts.icons.kinds = opts.icons.kinds or {}

      local miniicons = require("mini.icons")

      for _, entry in ipairs(entries) do
        opts.icons.kinds[entry] = miniicons.get("lsp", entry)
      end
    end,
  },
  {
    [1] = "snacks.nvim",
    optional = true,
    dependencies = { "mini.icons" },
    ---@param opts snacks.Config
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.icons = opts.picker.icons or {}
      opts.picker.icons.kinds = opts.picker.icons.kinds or {}
      local miniicons = require("mini.icons")

      for _, entry in ipairs(entries) do
        opts.picker.icons.kinds[entry] = miniicons.get("lsp", entry)
      end

      opts.picker.icons.kinds["Unknown"] = " "

      return opts
    end,
  },
}
