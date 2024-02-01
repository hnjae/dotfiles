local prefix = require("val").prefix.buffer

---@type LazySpec
return {
  [1] = "rest-nvim/rest.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
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
        json = vim.fn.executable("jq") == 1 and "jq" or "cat",
        html = function(body)
          if vim.fn.executable("tidy") == 1 then
            return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
          end
          return vim.fn.system({ "echo", "--" }, body)
        end,
      },
    },
  },
  cmd = { "RestLog", "RestSelectEnv" },
  keys = {
    {
      [1] = prefix .. "r",
      [2] = "<Plug>RestNvim",
      ft = "http",
      desc = "RestNvim",
    },
    {
      [1] = prefix .. "R",
      [2] = "<Plug>RestNvimPreview",
      ft = "http",
      desc = "RestNvimPreview",
    },
    {
      [1] = prefix .. "g",
      [2] = "<cmd>RestLog<CR>",
      ft = "http",
      desc = "RestLog",
    },
  },
}
