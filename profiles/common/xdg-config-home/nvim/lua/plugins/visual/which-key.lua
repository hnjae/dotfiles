local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "which-key.nvim",
  opts_extend = { "spec", "icons.rules" },
  optional = true,
  opts = {
    ---@type wk.Spec[]
    spec = {
      ----------------------------------------------------------------------------------------------
      -- override defaults rules
      ----------------------------------------------------------------------------------------------
      -- ※  먼저 오는 것이 우선순위가 높음
      rules = {
        { plugin = "yanky.nvim", icon = "󰅌 ", color = "yellow" },
        { pattern = "%f[%a]ai", icon = icons.ai, color = "green" }, -- nf-md-robot_outline
        { pattern = "terminal", icon = icons.terminal, color = "red" },
        { pattern = "find", icon = icons.search, color = "green" },
        { pattern = "search", icon = icons.search, color = "green" },
        { pattern = "buffer", icon = "󱇨 ", color = "cyan" },
        { pattern = "code", icon = icons.code, color = "orange" },
        { pattern = "debug", icon = " ", color = "red" }, -- nf-cod-debug
        { pattern = "file", icon = icons.file, color = "cyan" }, -- nf-md-file_outline
        { pattern = "file", icon = icons.file, color = "cyan" }, -- nf-md-file_outline
        { pattern = "format", icon = icons.sort, color = "cyan" },
        { pattern = "notif", icon = "󱥂 ", color = "blue" }, -- nf-md-message_badge_outline
        { pattern = "toggle", icon = "", color = "yellow" }, -- nf-md-toggle_switch_outline
      },
    },
  },
}
