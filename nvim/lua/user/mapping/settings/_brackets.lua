local M = {}

-- local status_hop, hop = pcall(require, "hop")

local status_wk, wk = pcall(require, "which-key")


M.setup = function()
  if not status_wk then
    return
  end

  local nkeymap = {
    ["[w"] = { vim.diagnostic.goto_prev, "warning" },
    ["]w"] = { vim.diagnostic.goto_next, "warning" },
    ["[g"] = { "<cmd>lua vim.diagnostic.goto_prev({ severity = {min=vim.diagnostic.severity.ERROR} })<CR>", "error" },
    ["]g"] = { "<cmd>lua vim.diagnostic.goto_next({ severity = {min=vim.diagnostic.severity.ERROR} })<CR>", "error" },
    -- ["[g"] = { vim.diagnostic.goto_prev({ severity = {min=vim.diagnostic.severity.ERROR} }), "error" },
    -- ["]g"] = { vim.diagnostic.goto_next({ severity = {min=vim.diagnostic.severity.ERROR} }), "error" },
  }
  wk.register(nkeymap, { mode = "n", silent = false, noremap = true, })
end

return M
