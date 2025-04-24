local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        -- override LazyVim's default
        header = "Hello world!",

        --stylua: ignore
        keys = {
          { icon = icons.search, key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = icons.file, key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = icons.filter, key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "󰾰 ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" }, -- nf-md
          { icon = "󰆏 ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" }, -- nf-md
          { icon = icons.cog, key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" }, -- nf-md
          { icon = "󰦛 ", key = "s", desc = "Restore Session", section = "session" }, -- nf-md-restore
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil }, -- nf-md-sleep
          { icon = "󰗽 ", key = "q", desc = "Quit", action = ":qa" }, -- nf-md-logout
        }
,
      },

      formats = {
        key = function(item)
          return {
            { [1] = "[", hl = "special" },
            { [1] = item.key, hl = "key" },
            { [1] = "]", hl = "special" },
          }
        end,
      },

      sections = {
        { section = "header" },
        -- { section = "startup", padding = 1 },

        { title = "Bookmarks", padding = 1 },
        { section = "keys", padding = 1 },

        { title = "MRU (CWD) ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
        { section = "recent_files", cwd = true, limit = 8, padding = 1 },

        { title = "Projects", padding = 1 },
        { section = "projects", padding = 1 },

        { title = "Sessions", padding = 1 },
        { section = "session", padding = 1 },

        -- { title = "MRU", padding = 1, pane = 3 },
        -- { section = "recent_files", limit = 8, padding = 1, pane = 3 },
      },
    },
  },
}
