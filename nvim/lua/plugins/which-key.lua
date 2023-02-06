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
      '("orgmode")',
    }, -- hide mapping boilerplate
  },
}
