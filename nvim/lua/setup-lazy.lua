-- bootstrap lazy.nvim
if vim.fn.has('nvim-0.8') ~= 1 then
  return
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { import = "plugins" },
  lockfile= vim.fn.stdpath("data") .. "/lazy-lock.json"
})
