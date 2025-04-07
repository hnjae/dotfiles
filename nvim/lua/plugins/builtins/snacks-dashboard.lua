---@type LazySpec
return {
  [1] = "folke/snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        -- override LazyVim's default
        header = "Hello world!",
      },

      formats = {
        key = function(item)
          return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        end,
      },

      sections = {
        { section = "header" },
        -- { section = "startup", padding = 1 },

        { title = "MRU (CWD) ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
        { section = "recent_files", cwd = true, limit = 8, padding = 1 },

        { title = "Projects", padding = 1 },
        { section = "projects", padding = 1 },

        { title = "Sessions", padding = 1 },
        { section = "session", padding = 1 },

        { title = "Bookmarks", padding = 1 },
        { section = "keys", padding = 1 },

        -- { title = "MRU", padding = 1, pane = 3 },
        -- { section = "recent_files", limit = 8, padding = 1, pane = 3 },
      },
    },
  },
}
