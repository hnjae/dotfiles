---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  opts = function()
    LazyVim.on_load("overseer.nvim", function()
      local overseer = require("overseer")

      local templates = {
        -- based on https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md
        {
          name = "run file",
          builder = function()
            local file = vim.fn.expand("%:p")

            local cmd
            if vim.bo.filetype == "go" then
              cmd = { "go", "run", file }
            elseif vim.bo.filetype == "typescript" then
              if vim.fn.executable("ts-node") == 1 then
                cmd = { "ts-node", file }
              else
                cmd = { "bun", file }
              end
            elseif vim.bo.filetype == "python" then
              cmd = { "ipython3", file }
            elseif vim.bo.filetype == "zsh" then
              cmd = { "zsh", file }
            elseif vim.bo.filetype == "sh" then
              cmd = { "bash", file }
            else
              cmd = { file }
            end

            return {
              cmd = cmd,
              components = {
                { [1] = "on_output_quickfix", set_diagnostics = true },
                "default",
                "on_result_diagnostics",
                -- "on_exit_set_status",
                -- "on_complete_dispose",
                "unique",
              },
            }
          end,
          condition = {
            filetype = { "sh", "python", "go", "zsh", "typescript" },
          },
        },
      }

      for _, template in ipairs(templates) do
        overseer.register_template(template)
      end
    end)
  end,
}
