-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022 Steven Arcangeli
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  opts = function()
    LazyVim.on_load("overseer.nvim", function()
      local overseer = require("overseer")

      local templates = {
        -- Based on the overseer.nvim tutorials (modified)
        -- Copyright (c) 2022 Steven Arcangeli
        -- Original licensed under the MIT License (see NOTICE.md in the nvim config root)
        -- Source: https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md
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
