--[[
NOTE:

※ `snacks.nvim` 의 스펙에서 `opts.explorer` 를 선언해도, 기본 키 바인딩에서 이를 consume 하지 않는다.

from LazyVim 14:

```lua
return {
  desc = "Snacks File Explorer",
  recommended = true,
  "folke/snacks.nvim",
  opts = { explorer = {} },
  keys = {
    {
      "<leader>fe",
      function()
        Snacks.explorer({ cwd = LazyVim.root() })
      end,
      desc = "Explorer Snacks (root dir)",
    },
    {
      "<leader>fE",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
  },
}
```
]]

local icons = require("globals").icons

-- ---@type snacks.picker.explorer.Config
local opts = {
  -- auto_close = true,

  layout = {
    preset = "sidebar",
    preview = false,
    layout = {
      -- default 50:
      width = 32,
    },
  },

  -- 이거 사용안되는 듯 <2025-04-24>
  icon = {
    files = {
      enabled = false,
      dir = icons.directory,
      dir_open = icons.directory_open,
      file = icons.file,
    },
  },

  win = {
    list = {
      keys = {
        -- file picker 랑 동작 통일:
        ["<c-t>"] = "tab", -- default: terminal
        ["<c-v>"] = "edit_vsplit",
        ["<c-s>"] = "edit_split",

        ["<c-s-t>"] = "terminal", -- terminal 맵핑 옮김
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
}

---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    -- NOTE: 이거 왜 안먹지. <2025-04-24>
    explorer = opts,
  },
  keys = function(_, keys)
    local snacks = require("snacks")

    vim.list_extend(keys, {
      {
        [1] = "<leader>fe",
        [2] = function()
          snacks.explorer(vim.tbl_extend("force", opts, {
            cwd = LazyVim.root(),
          }))
        end,
        desc = "Explorer Snacks (root dir)",
      },
      {
        [1] = "<leader>fE",
        [2] = function()
          snacks.explorer(vim.tbl_extend("force", opts, {
            cwd = vim.fn.expand("%:h"),
          }))
        end,
        desc = "Explorer Snacks (cwd)",
      },
      { [1] = "<leader>e", [2] = "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
      { [1] = "<leader>E", [2] = "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
    })

    return keys
  end,
}
