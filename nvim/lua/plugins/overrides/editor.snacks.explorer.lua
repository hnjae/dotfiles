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
---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  keys = function(_, keys)
    local snacks = require("snacks")

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
    }

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
