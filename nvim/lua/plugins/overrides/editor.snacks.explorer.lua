return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        explorer = {
          -- auto_close = true,

          -- layout = { preset = "vscode" },
          layout = {
            preset = "sidebar",
            layout = {
              width = 36, -- default 50
            },
          },

          win = {
            list = {
              keys = {
                -- file picker 랑 동작 통일:
                ["<c-t>"] = "tab", -- default: terminal
                ["<c-v>"] = "edit_vsplit",
                ["<c-s>"] = "edit_split",

                ["<c-r>"] = "terminal", -- terminal 맵핑 옮김
                ["<c-o>"] = "edit_split", -- netrw 의 `o` 에서 따옴

                -- NEW:
                ["P"] = "edit_split", -- netrw alike; default: toggle_preview; netrw: browes-in-previously-used-window
                ["p"] = "toggle_preview", -- netrw alike;
                ["o"] = "edit_split", -- netrw 랑 동작 일치화; default: explorer_open <2025-04-24>
                ["H"] = "list_top", -- netrw 랑 동작 일치화
                ["v"] = "edit_vsplit", -- netrw 랑 동작 일치화
                ["t"] = "tab", -- netrw 랑 동작 일치화
                ["gx"] = "explorer_open",
                ["gh"] = "toggle_hidden",
                ["gi"] = "toggle_ignore",
                ["I"] = "toggle_help_input", -- default: toggle_ignore; netrw: toggle banner
              },
            },
          },
        },
      },
    },
  },
  keys = function(_, keys)
    local snacks = require("snacks")

    vim.list_extend(keys, {
      {
        [1] = "<leader>fe",
        [2] = function()
          -- snacks.explorer(vim.tbl_extend("force", opts, {
          --   cwd = LazyVim.root(),
          -- }))
          snacks.explorer({
            cwd = LazyVim.root(),
          })
        end,
        desc = "Explorer Snacks (root dir)",
      },
      {
        [1] = "<leader>fE",
        [2] = function()
          -- snacks.explorer(vim.tbl_extend("force", opts, {
          --   cwd = vim.fn.expand("%:h"),
          -- }))
          snacks.explorer({
            cwd = vim.fn.expand("%:h"),
          })
        end,
        desc = "Explorer Snacks (cwd)",
      },
      { [1] = "<leader>e", [2] = "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
      { [1] = "<leader>E", [2] = "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
    })

    return keys
  end,
}
