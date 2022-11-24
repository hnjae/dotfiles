local M = {}

M.setup = function ()
  if not _IS_PLUGIN("vimspector") then
    return
  end
    vim.g.vimspector_install_gadgets = {
      "depugby"
    }
end

return M
