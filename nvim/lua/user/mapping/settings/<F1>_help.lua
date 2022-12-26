local M = {}

local status_telescope, t_builtin = pcall(require, "telescope.builtin")
local status_wk, wk = pcall(require, "which-key")

M.setup = function ()
  if not status_wk or not status_telescope then
    return
  end

  wk.register({
    ["<F1>"] = { t_builtin.help_tags, "help-tags" },
  })
end

return M
