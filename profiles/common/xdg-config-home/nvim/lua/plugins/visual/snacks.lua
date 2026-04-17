local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = function(_, opts)
    opts.toggle = {
      icon = {
        enabled = icons.toggle_on,
        disabled = icons.toggle,
      },
    }

    opts.picker = {
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
    }

    opts.styles = vim.tbl_deep_extend("force", opts.styles or {}, {
      terminal = {
        wo = {
          -- Snacks windows default to SnacksNormal -> NormalFloat.
          -- Keep the terminal on the editor background instead.
          winhighlight = table.concat({
            "Normal:Normal",
            "NormalNC:Normal",
            "WinBar:SnacksWinBar",
            "WinBarNC:SnacksWinBarNC",
            "FloatTitle:SnacksTitle",
            "FloatFooter:SnacksFooter",
            "WinSeparator:SnacksWinSeparator",
          }, ","),
        },
      },
    })
  end,
}
