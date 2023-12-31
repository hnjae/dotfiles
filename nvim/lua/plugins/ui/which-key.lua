return {
  -- set keymap / show keymap
  [1] = "folke/which-key.nvim",
  lazy = false,
  opts = {
    operators = {},
    hidden = {
      "<silent>",
      "<cmd>",
      "<Cmd>",
      "<CR>",
      "call",
      "lua",
      "^:",
      "^ ",
      "require",
      [[("orgmode")]],
    }, -- hide mapping boilerplate
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    local prefix = require("val").prefix
    local map_keyword = require("val").map_keyword

    local maps = {}
    for name, map in pairs(prefix) do
      maps[map] = { name = name }
    end

    -- TODO: dirty code. fix it <2023-12-26>
    maps[prefix.lang .. map_keyword.lsp] = { name = "+lsp" }
    maps[prefix.lang .. map_keyword.lsp .. "w"] = { name = "+workspace" }
    maps["g" .. map_keyword.lsp] = { name = "+lsp" }

    wk.register(maps, {})
  end,
}
