---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  opts = function()
    LazyVim.on_load("overseer.nvim", function()
      local overseer = require("overseer")

      local templates = {
        {
          name = "nix-build (`default.nix`)",
          builder = function()
            return {
              cmd = { "nix-build" },
              components = {
                -- { [1] = "on_output_quickfix", open = true },
                -- { [1] = "on_output_summarize", max_lines = 4 },
                -- "on_exit_set_status",
                "on_result_diagnostics",
                "on_complete_dispose",
                "unique",
              },
            }
          end,
          condition = {
            filetype = { "nix" },
          },
        },
        {
          name = "nix-eval-file",
          builder = function()
            local filepath = vim.fn.expand("%:p")
            return {
              [1] = "shell",
              cmd = string.format('nix eval --file "%s" | alejandra --quiet', filepath),
              components = {
                -- { [1] = "on_output_quickfix", open = true },
                -- "on_exit_set_status",
                "on_result_diagnostics",
                "on_complete_dispose",
                "unique",
              },
            }
          end,
          condition = {
            filetype = { "nix" },
          },
        },
        {
          name = "nix-eval-lambda-file",
          --  nix eval --impure --expr '(import ./default.nix)' | alejandra --quiet
          builder = function()
            local filepath = vim.fn.expand("%:p")
            return {
              -- cmd = { "go", "run", file }
              [1] = "shell",
              cmd = string.format(
                "nix eval --impure --expr '(import \"%s\" {})' | alejandra --quiet",
                filepath
              ),
              components = {
                "default",
                "unique",
                "timeout",
              },
              on_exit = function()
                vim.notify("Hi")
              end,
            }
          end,
          condition = {
            filetype = { "nix" },
          },
        },
      }

      for _, template in ipairs(templates) do
        overseer.register_template(template)
      end
    end)
  end,
}
