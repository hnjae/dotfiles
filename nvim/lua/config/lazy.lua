local M = {}

M.setup = function()
  if require("utils").is_root() then
    return
  end

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
    msg = "lazy.nvim requires git."
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
    ---@type LazySpec[]
    spec = {
      { import = "plugins.core" },
      { import = "plugins.ui" },
      { import = "plugins.editing" },
      { import = "plugins.feature" },
      { import = "plugins.sidebar" },
      { import = "plugins.lang" },
    },
    -- defaults = {
    --   lazy = true,
    -- },
    pills = require("utils").enable_icon,
    performance = {
      -- NOTE: nix를 사용할 경우, 시스템의 packpath를 사용할 것. <??>
      -- NOTE: -> treesitter 이슈로 더 이상 시스템의 packpath를 사용하지 않음 <2023-11-24>
      reset_packpath = true,
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  })
end

return M
