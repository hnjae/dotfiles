-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "<Leader><Leader>", ":", { desc = "cmdline" })

local M = {}

local package_path = (...)

-- clipboard
--------------------------------------------------------------------------------
-- stylua: ignore start
vim.keymap.set( { "n", "x", "s" }, "<F12>",   [["+y]], { desc = "yank-to-clipboard" } )
vim.keymap.set( { "n", "v", "s" }, "<S-F12>", [["+p]], { desc = "paste-from-clipboard" })
-- stylua: ignore end

local path = package_path .. ".setups"
local fpath = string.format("lua/%s/*.lua", string.gsub(path, "%.", "/"))
local paths = vim.fn.uniq(vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), fpath, false, true)))

for _, path_ in pairs(paths) do
  require(path .. "." .. path_:match("[^/\\]+$"):sub(1, -5)).setup()
end
