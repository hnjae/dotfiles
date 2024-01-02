local M = {}

M.setup = function()
  local msg
  if vim.fn.has("unix") == 0 then
    msg = "Only *nix are supported."
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  if vim.fn.has("nvim-0.8") == 0 then
    msg = "lazy.nvim requires Neovim version 0.8 or higher."
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  if vim.fn.executable("git") == 0 then
    msg = "lazy.nvim requires git to be installed."
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  -- bootstrap lazy.nvim
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
    spec = {
      { import = "plugins.ui" },
      { import = "plugins.sidebar" },
      { import = "plugins.editing" },
      { import = "plugins.lsp" },
      { import = "plugins.lang" },
      { import = "plugins.feature" },
      { import = "plugins.lib" },
    },
    performance = {
      -- NOTE: nix를 사용할 경우, 시스템의 packpath를 사용할 것. <??>
      -- NOTE: -> treesitter 이슈로 더 이상 시스템의 packpath를 사용하지 않음 <2023-11-24>
      reset_packpath = true,
    },
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  })
end

return M
