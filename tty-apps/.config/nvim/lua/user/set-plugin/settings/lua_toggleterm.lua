local M = {}
local status_toggleterm, toggleterm = pcall(require, "toggleterm")

M.setup = function ()
  if not status_toggleterm then
    return
  end
  toggleterm.setup()
end
return M
