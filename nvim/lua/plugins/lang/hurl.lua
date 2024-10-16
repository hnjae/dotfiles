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
    local prefix = require("val.prefix").execute
    local keyword = require("val.map-keyword").execute

    return {
      -- Run API request
      {
        [1] = prefix .. string.upper(keyword),
        [2] = "<cmd>HurlRunner<CR>",
        desc = "run-ALL-requests",
        ft = "hurl",
      },
      {
        [1] = prefix .. keyword,
        [2] = "<cmd>HurlRunnerAt<CR>",
        desc = "run-api-request",
        ft = "hurl",
      },
      {
        [1] = prefix .. "e",
        [2] = "<cmd>HurlRunnerToEntry<CR>",
        desc = "run-api-request-to-entry",
        ft = "hurl",
      },
      {
        [1] = prefix .. "m",
        [2] = "<cmd>HurlToggleMode<CR>",
        desc = "hurl-toggle-mode",
        ft = "hurl",
      },
      {
        [1] = prefix .. "v",
        [2] = "<cmd>HurlVerbose<CR>",
        desc = "run-api-in-verbose-mode",
        ft = "hurl",
      },
      -- Run Hurl request in visual mode
      {
        [1] = prefix,
        [2] = ":HurlRunner<CR>",
        desc = "hurl-runner",
        mode = "v",
        ft = "hurl",
      },
    }
  end,
  specs = {},
}
