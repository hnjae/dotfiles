---@type LazySpec
return {
  [1] = "toppair/peek.nvim",
  ft = { "markdown" },
  enabled = vim.fn.executable("deno") == 1,
  cond = not require("utils").is_console,
  build = "deno task --quiet build:fast",
  opts = function()
    local ret = {}
    if vim.fn.has("linux") == 1 then
      if vim.fn.executable("chromium") == 1 then
        ret.app = "chromium"
      else
        vim.notify("peek.nvim: chromium not installed")
      end
    end
    return ret
  end,
  ---@type LazyKeysSpec[]
  keys = {
    {
      [1] = require("val").prefix.buffer .. "p",
      [2] = "<cmd>Preview<CR>",
      desc = "preview-using-peek",
      ft = "markdown",
    },
    {
      [1] = require("val").prefix.buffer .. "P",
      [2] = "<cmd>PreviewClose<CR>",
      desc = "preview-close",
      ft = "markdown",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = { "markdown" },
      callback = function()
        vim.api.nvim_buf_create_user_command(
          0,
          "Preview",
          require("peek").open,
          {}
        )
        vim.api.nvim_buf_create_user_command(
          0,
          "PreviewClose",
          require("peek").open,
          {}
        )
      end,
    })
  end,
}
