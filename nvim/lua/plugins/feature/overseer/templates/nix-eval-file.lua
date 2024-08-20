return {
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
}
