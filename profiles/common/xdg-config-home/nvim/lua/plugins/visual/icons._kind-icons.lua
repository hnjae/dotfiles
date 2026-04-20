if vim.g.vscode then
  return {}
end

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

local function get_kind_icons()
  local ok, mini_icons = pcall(require, "mini.icons")
  if not ok then
    return nil
  end

  local kinds = {}
  for _, entry in ipairs(entries) do
    local icon = mini_icons.get("lsp", entry)
    kinds[entry] = icon
  end

  return kinds
end

---@type LazySpec[]
return {
  {
    [1] = "LazyVim",
    optional = true,
    dependencies = {
      { [1] = "mini.icons", optional = true },
    },
    ---@param opts LazyVimOptions
    opts = function(_, opts)
      local kinds = get_kind_icons()
      if kinds == nil then
        return
      end

      opts.icons = opts.icons or {}
      opts.icons.kinds = vim.tbl_extend("force", opts.icons.kinds or {}, kinds)
    end,
  },
  {
    [1] = "snacks.nvim",
    optional = true,
    dependencies = {
      { [1] = "mini.icons", optional = true },
    },
    ---@param opts snacks.Config
    opts = function(_, opts)
      local kinds = get_kind_icons()
      if kinds == nil then
        return
      end

      opts.picker = opts.picker or {}
      opts.picker.icons = opts.picker.icons or {}
      opts.picker.icons.kinds = vim.tbl_extend("force", opts.picker.icons.kinds or {}, kinds)
      opts.picker.icons.kinds["Unknown"] = " " -- nf-cod-question

      return opts
    end,
  },
}
