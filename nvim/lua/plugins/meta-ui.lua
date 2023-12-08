-- UI

-- local prefix = require("val").prefix

return {
  -- TODO: make following to support *.kdl, *.toml <2023-02-04, Hyunjae Kim>
  { "ap/vim-css-color" }, -- preview color

  -----------------------------------------------------------------------------
  -- changes vim's default ui
  -----------------------------------------------------------------------------
  {
    "rcarriga/nvim-notify",
    lazy = true,
    enabled = true,
    event = "VimEnter",
    opts = {
      -- fps = 60,
      render = "compact",
      stages = "static",
      -- stages = "fade_in_fade_out",
    },
    keys = {{"z" .. "n", nil, desc="noti-dismiss"}},
    config = function(plugin, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify

      local rhsmap = {
        ["noti-dismiss"] = notify.dismiss
      }

      for _, key in pairs(plugin.keys) do
        vim.keymap.set("n", key[1], rhsmap[key.desc], {desc=key.desc})
      end
    end
    -- config = function(_, opts)
    --   -- replace builtin notify
    -- end,
  },
  -- {
  --   "vigoux/notifier.nvim",
  --   lazy = true,
  --   enabled = false,
  --   event = "VimEnter",
  --   opts = {}
  -- },

  -----------------------------------------------------------------------------
  -- shows things
  -----------------------------------------------------------------------------
  {
    -- shows indent line
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    event = { "BufWritePost", "BufReadPost" },
  },
  {
    -- shows marks
    "chentoast/marks.nvim",
    lazy = true,
    enabled = true,
    event = { "BufWritePost", "BufReadPost" },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    -- ft = require("val").treesitter_fts,
    -- dependencies = {
    --   "nvim-treesitter/nvim-treesitter",
    -- },
    opts = {
      max_lines = 10,
      -- multiline_threshold = 10,
    },
  },
}
