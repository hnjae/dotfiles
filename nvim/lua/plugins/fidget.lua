--[[
  - NOTE: 우 하단, LSP 로딩하는것 알려주는 플러그인
    - <https://github.com/j-hui/fidget.nvim>
]]

---@type LazySpec
return {
  [1] = "j-hui/fidget.nvim",
  version = "*", -- uses sementic versioning

  lazy = true,
  event = "LspAttach",
  cond = not vim.g.vscode,

  opts = {
    logger = {
      path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("log")),
    },
  },
  specs = {
    {
      -- disable noice's lsp alerts
      [1] = "folke/noice.nvim",
      optional = true,
      opts = {
        lsp = {
          progress = {
            enabled = false,
          },
        },
      },
    },
  },
}
