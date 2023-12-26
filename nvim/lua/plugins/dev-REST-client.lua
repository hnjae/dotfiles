local prefix = require("val").prefix.lang

return {
  [1] = "rest-nvim/rest.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  lazy = true,
  ft = { "http" },
  opts = {
    highlight = {
      enabled = true,
    },
    result = {
      show_url = true,
      show_curl_command = true,
      show_http_info = true,
      show_headers = true,
      formatters = {
        json = "jq",
        html = function(body)
          return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
        end,
      },
    },
  },
  cmd = { "RestLog", "RestSelectEnv" },
  keys = {
    { [1] = prefix .. "r", [2] = "<Plug>RestNvim", ft = "http", desc = "RestNvim" },
    { [1] = prefix .. "R", [2] = "<Plug>RestNvimPreview", ft = "http", desc = "RestNvimPreview" },
    { [1] = prefix .. "g", [2] = "<cmd>RestLog<CR>", ft = "http", desc = "RestLog" },
  },
}
