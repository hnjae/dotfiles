-- UI

return {
  -- TODO: make following to support *.kdl, *.toml <2023-02-04, Hyunjae Kim>
  { "ap/vim-css-color" }, -- preview color
  -----------------------------------------------------------------------------
  -- changes vim's default ui
  -----------------------------------------------------------------------------
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      -- replace builtin notify
      vim.notify = require("notify")
    end,
  },
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
    lazy = false,
    enabled = true,
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
}
