-- 2024-02-01 copied from https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md
-- follows MIT license
return {
  name = "g++ build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "g++" },
      args = { file },
      components = { { [1] = "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
