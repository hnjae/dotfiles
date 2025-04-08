--[[
  - NOTE:
    - <https://github.com/Bekaboo/dropbar.nvim>
    - LazyVim 의 경우 lualine 에서 관련 내용을 제거 해야 중복되지 않는다.
]]

---@type LazySpec[]
return {
  {
    [1] = "Bekaboo/dropbar.nvim",
    version = "*", -- follows sementaic versioning

    lazy = true,
    event = "LspAttach",

    opts = {},
    -- local dropbar_api = require("dropbar.api")
    -- vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    -- vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    -- vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  },
  {
    [1] = "lualine.nvim",
    optional = true,
    opts = function(_, opts)
      -- HACK: lualine_c 의 마지막 elements 가 LazyVim.lualine.pretty_path() 인지 어떻게 아나? <2025-04-07>
      table.remove(opts.sections.lualine_c)
    end,
  },
}
