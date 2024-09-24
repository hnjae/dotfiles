---@type LazySpec
return {
  [1] = "jellydn/hurl.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    {
      [1] = "nvim-treesitter/nvim-treesitter",
      optional = true,
      opts = function()
        require("state.treesitter-langs"):add("hurl")
      end,
    },
  },
  cond = require("utils").is_treesitter,
  ft = "hurl",
  opts = {
    show_notification = false,
  },
  keys = function()
    local prefix = "<LocalLeader>x"

    return {
      -- Run API request
      {
        [1] = prefix .. "X",
        [2] = "<cmd>HurlRunner<CR>",
        desc = "Run All requests",
      },
      {
        [1] = prefix .. "x",
        [2] = "<cmd>HurlRunnerAt<CR>",
        desc = "Run Api request",
      },
      {
        [1] = prefix .. "te",
        [2] = "<cmd>HurlRunnerToEntry<CR>",
        desc = "Run Api request to entry",
      },
      {
        [1] = prefix .. "tm",
        [2] = "<cmd>HurlToggleMode<CR>",
        desc = "Hurl Toggle Mode",
      },
      {
        [1] = prefix .. "tv",
        [2] = "<cmd>HurlVerbose<CR>",
        desc = "Run Api in verbose mode",
      },
      -- Run Hurl request in visual mode
      {
        [1] = prefix .. "h",
        [2] = ":HurlRunner<CR>",
        desc = "Hurl Runner",
        mode = "v",
      },
    }
  end,
}
