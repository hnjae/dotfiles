local M = {}

M.setup = function ()
  if not _IS_PLUGIN("vimspector") then
    return
  end
end

return M
