local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "which-key.nvim",
  opts_extend = { "spec", "icons.rules" },
  optional = true,
  opts = {
    ---@type wk.Spec[]
    spec = {},
    ---@type wk.IconRule[]|false

    icons = {
      mappings = vim.o.termguicolors,
      rules = {
        { plugin = "yanky.nvim", icon = "󰅌", color = "yellow" },
        { plugin = "vim-dadbod-ui", icon = icons.database, color = "yellow" },

        -- 동사
        { pattern = "find", icon = icons.search, color = "green" },
        { pattern = "run", icon = "󰑮", color = "blue" },
        { pattern = "search", icon = icons.search, color = "green" },
        { pattern = "split", icon = "󱤗", color = "" }, -- nf-md-format_page_split
        { pattern = "toggle", icon = icons.toggle, color = "yellow" },
        { pattern = "switch", icon = "", color = "yellow" }, -- nf-oct-arrow_switch
        { pattern = "next", icon = "󰁔", color = "" }, -- nf-md-arrow_right
        { pattern = "prev", icon = "󰁍", color = "" }, -- nf-md-arrow_left
        { pattern = "new", icon = "󰏌", color = "" }, -- nf-md-open_in_new
        { pattern = "paste", icon = "󰆒", color = "" }, -- nf-md-content_paste
        { pattern = "select", icon = "󰒅", color = "" }, -- nf-md-select
        -----------------------------------
        -- override defaults rules
        -----------------------------------
        -- ※  먼저 오는 것이 우선순위가 높음

        { pattern = "%f[%a]ai", icon = icons.ai, color = "green" },
        { pattern = "code", icon = icons.code, color = "orange" },
        { pattern = "debug", icon = icons.bug, color = "red" },
        { pattern = "format", icon = icons.sort, color = "cyan" },
        { pattern = "notif", icon = "󱥂", color = "blue" }, -- nf-md-message_badge_outline
        { pattern = "terminal", icon = icons.terminal, color = "red" },

        -- { plugin = "fzf-lua", cat = "filetype", name = "fzf" },
        -- { plugin = "zen-mode.nvim", icon = "󱅻 ", color = "cyan" },
        -- { plugin = "telescope.nvim", pattern = "telescope", icon = "", color = "blue" },
        -- { plugin = "grapple.nvim", pattern = "grapple", icon = "󰛢", color = "azure" },
        -- { plugin = "nvim-spectre", icon = "󰛔 ", color = "blue" },
        -- { plugin = "grug-far.nvim", pattern = "grug", icon = "󰛔 ", color = "blue" },
        -- { plugin = "noice.nvim", pattern = "noice", icon = "󰈸", color = "orange" },
        -- { plugin = "persistence.nvim", icon = " ", color = "azure" },
        -- { plugin = "neotest", cat = "filetype", name = "neotest-summary" },
        -- { plugin = "lazy.nvim", cat = "filetype", name = "lazy" },
        -- { plugin = "refactoring.nvim", pattern = "refactor", icon = " ", color = "cyan" },
        -- { pattern = "profiler", icon = "⚡", color = "orange" },
        -- { plugin = "CopilotChat.nvim", icon = " ", color = "orange" },
        -- { pattern = "%f[%a]git", cat = "filetype", name = "git" },
        -- { pattern = "test", cat = "filetype", name = "neotest-summary" },
        -- { pattern = "lazy", cat = "filetype", name = "lazy" },
        -- { pattern = "window", icon = " ", color = "blue" },
        -- { pattern = "diagnostic", icon = "󱖫 ", color = "green" },
        -- { pattern = "session", icon = " ", color = "azure" },
        -- { pattern = "exit", icon = "󰈆 ", color = "red" },
        -- { pattern = "quit", icon = "󰈆 ", color = "red" },
        -- { pattern = "ui", icon = "󰙵 ", color = "cyan" },

        -- 후순위 (목적어)
        { pattern = "file", icon = icons.file, color = "cyan" },
        { pattern = "tab", icon = "", color = "purple" },
        { pattern = "buffer", icon = icons.file_edit, color = "cyan" },

        -- DISABLE
        -- { plugin = "snacks.nvim", icon = "", color = "purple" },
      },
    },
  },
}
