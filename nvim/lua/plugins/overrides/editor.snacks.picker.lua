-- <https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-config>

local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "snacks.nvim",
  dir = "/home/hnjae/git/snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    picker = {
      debug = {
        explorer = true,
      },
      -- formatters = {
      --   text = {
      --     ft = nil, ---@type string? filetype for highlighting
      --   },
      --   file = {
      --     icon_width = 2, -- width of the icon (in characters)
      --   },
      -- },

      -- 이거 무시됨 <2025-04-24>
      -- ---@type snacks.picker.icons
      icon = {
        files = {
          enabled = false,
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

      win = {
        input = {
          keys = {
            ["<c-o>"] = { "edit_split", mode = { "i", "n" } }, -- netrw 의 `o` 에서 따옴
          },
        },
      },
    },
  },
}
