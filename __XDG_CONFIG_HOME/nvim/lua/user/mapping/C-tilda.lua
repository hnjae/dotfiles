local M = {}

local status_wk, wk = pcall(require, "which-key")

function M.setup()
  if not status_wk then
    return
  end

  wk.register({
    ["<C-`>"] = { "<cmd>ToggleTerm<CR>", "open-terminal" },
  })
end

return M
