return {
  -- set keymap / show keymap
  "folke/which-key.nvim",
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

    local maps = {}
    for name, map in pairs(require("val").prefix) do
      maps[map] = { name = name }
    end
    wk.register(maps, {})
  end,
}
