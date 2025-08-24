---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  opts = function()
    LazyVim.on_load("overseer.nvim", function()
      local overseer = require("overseer")

      local templates = {
        -- from https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md
        {
          name = "compile main.typ",
          builder = function()
            -- Full path to current file (see :help expand())
            -- local file = vim.fn.expand("%:p")

            return {
              cmd = { "typst" },
              args = { "compile", "--", "main.py" },
              cwd = vim.fn.expand("%:p:h"),
              components = {
                -- { [1] = "on_output_quickfix", open = true },
                { "on_result_diagnostics", open = true },
                "unique",
                -- "default",
              },
            }
          end,
          condition = {
            filetype = { "typst" },
          },
        },
      }

      for _, template in ipairs(templates) do
        overseer.register_template(template)
      end
    end)
  end,
}
