--[[
  - NOTE:
    - <https://github.com/Bekaboo/dropbar.nvim>
    - LazyVim 의 경우 lualine 에서 관련 내용을 제거 해야 중복되지 않는다.
]]

-- froym `opts.icons.kinds.symbols`: `table<string, string>`
local symbols = {
  Array = "󰅪 ",
  Boolean = " ",
  Class = " ",
  Color = "󰏘 ",
  Constant = "󰏿 ",
  Constructor = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = "󰈔 ",
  Folder = "󰉋 ",
  Function = "󰊕 ",
  Interface = " ",
  Keyword = "󰌋 ",
  Method = "󰆧 ",
  Module = "󰏗 ",
  Namespace = "󰅩 ",
  Null = "󰢤 ",
  Number = "󰎠 ",
  Object = "󰅩 ",
  Operator = "󰆕 ",
  Package = "󰆦 ",
  Property = " ",
  Reference = "󰦾 ",
  Snippet = "󰩫 ",
  String = "󰉾 ",
  Struct = " ",
  Text = " ",
  TypeParameter = "󰆩 ",
  Unit = " ",
  Value = "󰎠 ",
  Variable = "󰀫 ",
}

---@type LazySpec[]
return {
  {
    [1] = "Bekaboo/dropbar.nvim",
    version = "*", -- follows sementaic versioning
    dependencies = { "echasnovski/mini.icons" },

    lazy = true,
    event = "LspAttach",

    opts = function(_, opts)
      opts.icons = opts.icons or {}
      opts.icons.kinds = opts.icons.kinds or {}
      opts.icons.kinds.symbols = opts.icons.kinds.symbols or {}

      -- Mini.icons 에서 지원하지 않는 아이콘 추가
      opts.icons.kinds.symbols = vim.tbl_extend("force", opts.icons.kinds.symbols or {}, {
        -- BreakStatement = "󰙧 ",
        Call = " ",
        -- CaseStatement = "󱃙 ",
        -- ContinueStatement = "→ ",
        Copilot = " ",
        -- Declaration = "󰙠 ",
        -- Delete = "󰩺 ",
        -- DoStatement = "󰑖 ",
        -- ForStatement = "󰑖 ",
        -- H1Marker = "󰉫 ", -- Used by markdown treesitter parser
        -- H2Marker = "󰉬 ",
        -- H3Marker = "󰉭 ",
        -- H4Marker = "󰉮 ",
        -- H5Marker = "󰉯 ",
        -- H6Marker = "󰉰 ",
        -- Identifier = "󰀫 ",
        -- IfStatement = "󰇉 ",
        List = " ", -- 󰅪
        -- Log = "󰦪 ",
        Lsp = " ", -- default
        -- Macro = "󰁌 ",
        -- MarkdownH1 = "󰉫 ", -- Used by builtin markdown source
        -- MarkdownH2 = "󰉬 ",
        -- MarkdownH3 = "󰉭 ",
        -- MarkdownH4 = "󰉮 ",
        -- MarkdownH5 = "󰉯 ",
        -- MarkdownH6 = "󰉰 ",
        -- Pair = "󰅪 ",
        Regex = " ", -- default
        -- Repeat = "󰑖 ",
        Scope = " ", -- 󰅩
        -- Specifier = "󰦪 ",
        Statement = " ", -- 󰅩
        -- SwitchStatement = "󰺟 ",
        Table = " ", -- 󰅩
        Terminal = " ",
        Type = " ", -- default
        -- WhileStatement = "󰑖 ",
      })

      local miniicons = require("mini.icons")
      for entry, _ in pairs(symbols) do
        opts.icons.kinds.symbols[entry] = miniicons.get("lsp", entry) .. " "
      end
    end,
  },
  {
    [1] = "lualine.nvim",
    optional = true,
    opts = function(_, opts)
      -- HACK: lualine_c 의 마지막 elements 가 LazyVim.lualine.pretty_path() 인지 어떻게 아나? <2025-04-07>
      table.remove(opts.sections.lualine_c, 5)
    end,
  },
}
