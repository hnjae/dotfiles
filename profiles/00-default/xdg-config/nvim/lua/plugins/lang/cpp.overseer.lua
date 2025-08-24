---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  opts = function()
    LazyVim.on_load("overseer.nvim", function()
      local overseer = require("overseer")

      local templates = {
        {
          -- from https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md
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
        },
      }

      for _, template in ipairs(templates) do
        overseer.register_template(template)
      end
    end)
  end,
}
