--[[
  - NOTE: 우 하단, LSP 로딩하는것 알려주는 플러그인
    - <https://github.com/j-hui/fidget.nvim>
]]

---@type LazySpec
return {
  [1] = "j-hui/fidget.nvim",
  version = "*", -- uses semantic versioning

  lazy = true,
  event = "LspAttach",
  cond = not vim.g.vscode,

  opts = {
    notification = {
      window = {
        -- normal_hl = "ColorColumn",
        -- winblend = 0,
        y_padding = 0, -- Padding from bottom edge of window boundary
        x_padding = 0, -- Padding from right edge of window boundary
        align = "bottom", -- How to align the notification window
        relative = "win", -- What the notification window position is relative to
        -- border = "single",
      },
    },
    logger = {
      path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("log")),
    },
  },
  specs = {
    {
      -- disable noice's lsp alerts
      [1] = "noice.nvim",
      optional = true,
      ---@type NoiceConfig
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
