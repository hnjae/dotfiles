-- coc needs these config to work
local M = {}

M.setup = function()

  -- if hidden is not set, TextEdit might fail.
  vim.opt.hidden = true

  -- Some servers have issues with backup files, see #649
  vim.opt.backup = false
  vim.opt.writebackup = false

  -- Better display for messages
  vim.opt.cmdheight = 2

  -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  -- delays and poor user experience.
  vim.opt.updatetime=300

  -- Don't pass messages to |ins-completion-menu|.
  vim.opt.shortmess:append("c")

  -- Always show the signcolumn, otherwise it would shift the text each time
  -- diagnostics appear/become resolved.
  if vim.fn.has("nvim-0.5.0") then
    -- Recently vim can merge signcolumn and number column into one
    vim.opt.signcolumn = "number"
  else
    vim.optsigncolumn= "yes"
  end

  -- to use coc-highlight
  vim.opt.termguicolors = true

end

return M
