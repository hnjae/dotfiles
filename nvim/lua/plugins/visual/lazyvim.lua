local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "LazyVim",
  optional = true,
  ---@type LazyVimOptions
  opts = {
    icons = {
      diagnostics = {
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
