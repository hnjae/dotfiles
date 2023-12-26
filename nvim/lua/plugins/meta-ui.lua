-- UI
--
-- TODO: check https://gitlab.com/HiPhish/rainbow-delimiters.nvim <2023-12-26>

return {
  -- TODO: make following to support *.kdl, *.toml <2023-02-04, Hyunjae Kim>
  -- TODO: check: https://github.com/brenoprata10/nvim-highlight-colors
  { "ap/vim-css-color" }, -- preview color

  -----------------------------------------------------------------------------
  -- changes vim's default ui
  -----------------------------------------------------------------------------
  {
    -- alternative:  "vigoux/notifier.nvim",
    [1] = "rcarriga/nvim-notify",
    lazy = true,
    enabled = true,
    event = "VimEnter",
    opts = {
      -- fps = 60,
      render = "compact",
      stages = "static",
      -- stages = "fade_in_fade_out",
    },
    keys = { { [1] = "z" .. "n", [2] = nil, desc = "noti-dismiss" } },
    config = function(plugin, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify

      local rhsmap = {
        ["noti-dismiss"] = notify.dismiss,
      }

      for _, key in pairs(plugin.keys) do
        vim.keymap.set("n", key[1], rhsmap[key.desc], { desc = key.desc })
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- shows things
  -----------------------------------------------------------------------------
  {
    -- shows indent line
    [1] = "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    event = { "BufNewFile", "BufReadPost" },
    main = "ibl",
    opts = {},
  },
  {
    -- shows marks
    [1] = "chentoast/marks.nvim",
    lazy = true,
    enabled = true,
    event = { "BufNewFile", "BufReadPost" },
    opts = {},
  },
  {
    [1] = "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    dependencies = {
      [1] = "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      max_lines = 3,
    },
  },
  {
    [1] = "HiPhish/rainbow-delimiters.nvim",
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    lazy = false,
    dependencies = {
      [1] = "nvim-treesitter/nvim-treesitter",
    },
  }
}
