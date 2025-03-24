---@type LazySpec
return {
  [1] = "kawre/leetcode.nvim",
  lazy = true,
  cond = not vim.g.vscode,

  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    -- "nvim-lua/plenary.nvim", -- required by telescope
    "MunifTanjim/nui.nvim",

    -- optional
    "nvim-treesitter/nvim-treesitter",
    { [1] = "rcarriga/nvim-notify", optional = true },
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    lang = "typescript",
    storage = {
      home = vim.fn.stdpath("data") .. "/leetcode",
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },
  },
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        require("state.lualine-ft-data"):add({
          ["leetcode.nvim"] = { display_name = "LeetCode", icon = "" }, -- nf-oct-code_review
        })
      end,
    },
  },
}
