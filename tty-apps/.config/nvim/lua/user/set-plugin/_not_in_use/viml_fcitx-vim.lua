local M = {}

M.setup = function ()
  if not _IS_PLUGIN("fcitx.vim") then
    return
  end

  vim.g.fcitx5_remote = nil

  rasts
end

return M
