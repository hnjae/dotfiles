-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

----------------------------------------------------------------------------------------------------
-- REMOVE LazyVim keymaps
----------------------------------------------------------------------------------------------------
vim.keymap.del("n", "<leader>bo") -- bufdelete (LazyVim 14.15.0), 잘못 클릭이 잦아서 삭제
vim.keymap.del("n", "<S-h>") -- bprevious buffer (LazyVim 14.15.0), 잘못 클릭이 잦아서 삭제
vim.keymap.del("n", "<S-l>") -- bnext buffer (LazyVim 14.15.0), 잘못 클릭이 잦아서 삭제
vim.keymap.del("n", "<leader>ua") -- toggle animation <LazyVim 14.14.0>, 애니메이션을 실수로라도 키고 싶지 않음.

-- stylua: ignore start
vim.keymap.del({ "i", "s" }, "<C-s>") -- restore vim.lsp.buf.signature_help (LazyVim 14.14.0 :w 로 맵핑되어 있음)
vim.keymap.set({ "i", "s" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "lsp-buf-signature-help" })

vim.keymap.del({ "n", "x" }, "<C-s>") -- extend vim.lsp.buf.signature_help
vim.keymap.set({ "n", "x" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "lsp-buf-signature-help" })
-- stylua: ignore end

vim.keymap.del({ "n", "x" }, "j") -- j 가 특졍 경우 gj 로 동작하는 것 삭제 (LazyVim 14.14.0)
vim.keymap.del({ "n", "x" }, "<Down>")
vim.keymap.del({ "n", "x" }, "k")
vim.keymap.del({ "n", "x" }, "<Up>")

--------------------------------------------------------------------------------

vim.keymap.set({ "i", "x", "n", "s" }, "<F4>", "<cmd>w<cr><C-\\><C-n>", { desc = "Save File" })
vim.keymap.set({ "n", "i", "c", "x", "s", "o", "t" }, "<F6>", function()
  vim.cmd("wincmd w")
end, { desc = "move-cursor" })

-- clipboard
--------------------------------------------------------------------------------
-- stylua: ignore start
vim.keymap.set( { "x", "s" }, "<F12>", [["+y]], { desc = "yank-to-clipboard" } )
vim.keymap.set( { "n", "x" }, "<F24>", [["+p]], { desc = "paste-from-clipboard" }) -- S-F12
-- stylua: ignore end

vim.keymap.set({ "n" }, "<BS>", ":", { desc = "cmdline" })
vim.keymap.set({ "n" }, "<S-BS>", ":<C-u>lua ", { desc = "lua" })

--  escape teriminal/mapping (WIP)
--------------------------------------------------------------------------------
vim.keymap.set({ "t" }, "<S-Esc>", "<C-\\><C-n>", { desc = "escape-terminal" })
vim.keymap.set({ "i", "t" }, "<C-e>", "<C-\\><C-n>", { desc = "escape-terminal" })

----------------------------------------------------------------------------------------------------

local package_path = (...)

local path = package_path .. ".setups"
local fpath = string.format("lua/%s/*.lua", string.gsub(path, "%.", "/"))
local paths =
  vim.fn.uniq(vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), fpath, false, true)))

for _, path_ in pairs(paths) do
  require(path .. "." .. path_:match("[^/\\]+$"):sub(1, -5)).setup()
end
