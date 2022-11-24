local M = {}

local status_wk, wk = pcall(require, "which-key")

function M.setup()
  if not status_wk then
    return
  end


  -- vim.cmd([[
  -- nmap <C-`> :ToggleTerm<CR>
  -- ]])
  -- vim.api.nvim_set_keymap("n", "<C-`>", "<cmd>ToggleTerm<CR>", {})

  wk.register({
    ["<leader>t"] = { "<cmd>ToggleTerm<CR>", "open-terminal" },
  })
end

return M
