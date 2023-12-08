-- TODO: use copilot-cmp.lua instead of official version <2023-11-14>

vim.g.copilot_no_tab_map = true

return {
  "github/copilot.vim",
  lazy = true,
  enabled = false,
  -- event = { "InsertEnter" },
  ft = {
    "javascript",
    "typescript",
    "lua",
    "python",
  },
  cond = vim.fn.executable("node") == 1,
  config = function()
    vim.cmd([[
        imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
    ]])
  end,
}
