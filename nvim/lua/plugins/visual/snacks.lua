local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    toggle = {
      icon = {
        enabled = icons.toggle_on,
        disabled = icons.toggle,
      },
    },

    picker = {
      icons = {
        files = {
          dir = icons.directory,
          dir_open = icons.directory_open,
          file = icons.file,
        },

        lsp = {
          enabled = icons.toggle_on,
          disabled = icons.toggle,
        },

        diagnostics = {
          Error = icons.severity.error,
          Warn = icons.severity.warn,
          Info = icons.severity.info,
          Hint = icons.severity.hint,
        },
      },
    },
  },
}
