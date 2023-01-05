local M = {}

local status_wk, wk = pcall(require, "which-key")

M.setup = function()
  vim.api.nvim_set_keymap("n", "ZA", "<cmd>wa<CR>", {})

  if status_wk and vim.fn.has("nvim-0.8.0") then
    wk.register(
      {
        ["Zl"] = {
          function()
            -- for _, buf_client in pairs(vim.lsp.buf_get_clients()) do
            for _, buf_client in pairs(vim.lsp.get_active_clients({bufnr = 0})) do
              buf_client.stop()
            end
          end,
          'stop-lsp'
        },
      },
      { mode = "n", silent = true, noremap = true }
    )
  end

end

return M
