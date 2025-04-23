---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    toggle = {
      icon = {
        enabled = "󱨥 ",
        disabled = "󱨦 ",
      },
    },
    picker = {
      icon = {
        files = {
          enabled = true, -- show file icons
          dir = "󰉖 ",
          dir_open = "󰷏 ",
          file = " ",
        },

        lsp = {
          enabled = "󱨥 ",
          disabled = "󱨦 ",
        },
      },
    },
  },
}
