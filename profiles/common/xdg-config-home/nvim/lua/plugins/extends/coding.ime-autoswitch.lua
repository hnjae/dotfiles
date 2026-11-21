-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec
return {
  -- dir = vim.fn.getenv("HOME") .. "/Projects/fcitx.nvim"
  -- enabled = vim.loop.fs_stat(dir_) ~= nil,
  [1] = "hnjae/fcitx.nvim",
  name = "fcitx",
  opts = { sleep = 0.2 },
  lazy = true,
  event = {
    "InsertEnter",
  },
}
