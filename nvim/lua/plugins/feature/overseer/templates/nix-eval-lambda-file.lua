return {
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
}
