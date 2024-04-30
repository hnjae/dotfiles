---@type LazySpec
return {
  [1] = "folke/noice.nvim",
  optional = true,
  opts = function(_, opts)
    if not opts.lsp then
      opts.lsp = {}
    end

    opts.lsp.signature = {
      -- NOTE: 계속 signature hover window를 띄어놓는 법을 모르겠음 <2024-04-06>
      enabled = true,
      view = "hover",
      auto_open = {
        luasnip = require("utils").is_plugin("luasnip"),
      },
      ---@type NoiceViewOptions
      -- opts = {
      --   replace = true,
      -- },
    }
  end,
}
