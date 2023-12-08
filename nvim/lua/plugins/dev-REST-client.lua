local prefix = require("val").prefix.lang

-- or use nvim_buf_set_keymap
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "http" },
  -- group = au_id,
  desc = "Set keymaps for rest.nvim",
  callback = function()
    vim.keymap.set("n", prefix .. "r", "<Plug>RestNvim", { noremap = true, silent = true, buffer = 0 })
    vim.keymap.set("n", prefix .. "R", "<Plug>RestNvimPreview", { noremap = true, silent = true, buffer = 0 })
    vim.keymap.set("n", prefix .. "l", "<cmd>RestLog<CR>", { noremap = true, silent = true, buffer = 0 })
  end,
})

return {
  "rest-nvim/rest.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  lazy = false,
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
  ft = { "http" },
  cmd = { "RestLog", "RestSelectEnv" },
}
