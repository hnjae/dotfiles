local M = {}

local status_comment, comment = pcall(require, "Comment")

M.setup = function()
  if not status_comment then
    return
  end

  -- local config = {
  --   toggler = {
  --     bblock = 'gBc'
  --   },
  --
  --   opleader = {
  --       ---Block-comment keymap
  --       block = 'gB',
  --   },
  -- }
  -- vim.cmd([[
  -- nmap gb ""
  -- ]])
  comment.setup()
end

return M
