-- <https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-config>

local icons = require("globals").icons

local get_cwd = function()
  if vim.bo.buftype ~= "" then
    return vim.uv.cwd()
  end
  return vim.fn.expand("%:h")
end

---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
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

      win = {
        input = {
          keys = {
            ["<c-o>"] = { "edit_split", mode = { "i", "n" } }, -- netrw 의 `o` 에서 따옴
          },
        },
      },

      sources = {
        select = {
          layout = {
            preset = "select",
            layout = {
              -- width = 80,
            },
          },
        },
      },
    },
  },
  keys = {
    { [1] = "<F1>", [2] = "<leader>sh", remap = true },
    {
      [1] = "<leader>fF",
      [2] = function()
        Snacks.picker.files({
          cwd = get_cwd(),
        })
      end,
      desc = "Find Files (buffer's dir)",
    },
    {
      [1] = "<leader>sG",
      [2] = function()
        Snacks.picker.grep({
          cwd = get_cwd(),
        })
      end,
      desc = "Grep (buffer's dir)",
    },
    {
      "<leader>sW",
      [2] = function()
        Snacks.picker.grep_word({
          cwd = get_cwd(),
        })
      end,
      desc = "Visual selection or word (buffer's dir)",
      mode = { "n", "x" },
    },
  },
}
