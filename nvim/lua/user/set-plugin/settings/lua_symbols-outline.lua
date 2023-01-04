local M = {}

M.setup = function()
  local status, symbols_outline = pcall(require, "symbols-outline")

  if not status then
    return
  end


  local opts = {
    width = 17
  }
  symbols_outline.setup(opts)

end

return M
