local M = {}

local status_wk, wk = pcall(require, "which-key")

function M.setup()
  if not status_wk then
    return
  end

  -- vim.cmd([[
  -- map "<F2>" "<C-w>w"
  -- ]])
  wk.register({
    ["<F4>"] = { "<C-w>w", "C-w" },
  })
end

return M
