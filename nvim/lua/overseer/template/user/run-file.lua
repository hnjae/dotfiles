-- based on https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md
return {
  name = "run file",
  builder = function()
    local file = vim.fn.expand("%:p")

    local cmd
    if vim.bo.filetype == "go" then
      cmd = { "go", "run", file }
    elseif vim.bo.filetype == "typescript" then
      cmd = { "bun", file }
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
}

-- note: default:
-- { "display_duration", detail_level = 2 },
-- "on_output_summarize",
-- "on_exit_set_status",
-- "on_complete_notify",
-- "on_complete_dispose",
