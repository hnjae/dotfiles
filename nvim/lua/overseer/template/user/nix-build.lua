return {
  name = "nix-build (none flake)",
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
}
