-- <https://github.com/obsidian-nvim/obsidian.nvim>

---@type LazySpec
return {
  [1] = "obsidian-nvim/obsidian.nvim",
  version = false,
  cond = not vim.g.vscode,

  lazy = true,
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },

  opts = {
    workspaces = {
      {
        name = "home",
        path = "~/Documents/obsidian/home",
      },
    },
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "journals",
      -- Optional, if you want to change the date format for the ID of daily notes.
      -- date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      -- alias_format = "%B %-d, %Y",
      -- Optional, default tags to add to each new daily note created.
      -- default_tags = { "journals" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
    },
    completion = {
      nvim_cmp = true,
      blink = false,
    },
  },
  specs = {},
}
