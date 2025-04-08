--[[
  - NOTE:
    - <https://github.com/Bekaboo/dropbar.nvim>
    - LazyVim 의 경우 lualine 에서 관련 내용을 제거 해야 중복되지 않는다.
]]

---@type LazySpec
return {
  [1] = "Bekaboo/dropbar.nvim",
  version = "*", -- follows sementaic versioning

  lazy = true,
  event = "LspAttach",

  opts = {},
  -- local dropbar_api = require("dropbar.api")
  -- vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
  -- vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
  -- vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
}
