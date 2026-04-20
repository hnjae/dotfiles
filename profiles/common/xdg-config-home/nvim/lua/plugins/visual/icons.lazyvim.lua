local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "LazyVim",
  optional = true,
  ---@type LazyVimOptions
  opts = {
    icons = {
      diagnostics = {
        Error = icons.severity.error .. " ",
        Warn = icons.severity.warn .. " ",
        Info = icons.severity.info .. " ",
        Hint = icons.severity.hint .. " ",
      },
      git = {
        added = " ", -- nf-cod-diff_added
        modified = " ", -- nf-cod-diff_modified
        removed = " ", -- nf-cod-diff_renamed
      },
      dap = {
        -- Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" }, -- nf-md
        Breakpoint = "󰙧 ", -- nf-md
        BreakpointCondition = "󰋗 ", -- nf-md
        BreakpointRejected = { "󰀨 ", "DiagnosticError" }, -- nf-md
        -- LogPoint = ".>",
      },
    },
  },
}

-- icons = {
--   misc = {
--     dots = "󰇘",
--   },
--   ft = {
--     octo = " ",
--     gh = " ",
--     ["markdown.gh"] = " ",
--   },
--   dap = {
--     Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
--     Breakpoint          = " ",
--     BreakpointCondition = " ",
--     BreakpointRejected  = { " ", "DiagnosticError" },
--     LogPoint            = ".>",
--   },
--   diagnostics = {
--     Error = " ",
--     Warn  = " ",
--     Hint  = " ",
--     Info  = " ",
--   },
--   git = {
--     added    = " ",
--     modified = " ",
--     removed  = " ",
--   },
--   kinds = {
--     Array         = " ",
--     Boolean       = "󰨙 ",
--     Class         = " ",
--     Codeium       = "󰘦 ",
--     Color         = " ",
--     Control       = " ",
--     Collapsed     = " ",
--     Constant      = "󰏿 ",
--     Constructor   = " ",
--     Copilot       = " ",
--     Enum          = " ",
--     EnumMember    = " ",
--     Event         = " ",
--     Field         = " ",
--     File          = " ",
--     Folder        = " ",
--     Function      = "󰊕 ",
--     Interface     = " ",
--     Key           = " ",
--     Keyword       = " ",
--     Method        = "󰊕 ",
--     Module        = " ",
--     Namespace     = "󰦮 ",
--     Null          = " ",
--     Number        = "󰎠 ",
--     Object        = " ",
--     Operator      = " ",
--     Package       = " ",
--     Property      = " ",
--     Reference     = " ",
--     Snippet       = "󱄽 ",
--     String        = " ",
--     Struct        = "󰆼 ",
--     Supermaven    = " ",
--     TabNine       = "󰏚 ",
--     Text          = " ",
--     TypeParameter = " ",
--     Unit          = " ",
--     Value         = " ",
--     Variable      = "󰀫 ",
--   },
-- },
