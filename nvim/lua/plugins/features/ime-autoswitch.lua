---@type LazySpec
return {
  -- dir = vim.fn.getenv("HOME") .. "/Projects/fcitx.nvim"
  -- enabled = vim.loop.fs_stat(dir_) ~= nil,
  [1] = "hnjae/fcitx.nvim",
  name = "fcitx",
  opts = { sleep = 0.13 },
  lazy = true,
  event = {
    "InsertEnter",
  },
}

-- return {
--   "hnjae/fcitx.nvim",
--   lazy = false,
--   opts = { sleep = 0.1323 },
-- }
