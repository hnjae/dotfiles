-- HACK: hacky way to customize the pinned icon <2025-04-18>

--[[
NOTE:

- <https://github.com/akinsho/bufferline.nvim/issues/981>
- pinned buffer icon is not customizable via config
]]

---@type LazySpec
return {
  [1] = "bufferline.nvim",
  optional = true,
  opts = function()
    local groups = require("bufferline.groups")
    groups.builtin.pinned.icon = " "
  end,
}
