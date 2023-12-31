local dir_ = vim.fn.getenv("HOME") .. "/Projects/fcitx.nvim"

return {
  dir = dir_,
  -- enabled = true,
  enabled = vim.loop.fs_stat(dir_) ~= nil,
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
