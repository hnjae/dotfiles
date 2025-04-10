---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  opts = function(_, opts)
    -- DO NOT USE mason.nvim since `mypy` requires to read library stub
    if vim.fn.executable("mypy") == 1 then
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.python = opts.linters_by_ft.python or {}
      table.insert(opts.linters_by_ft.python, "mypy")
    end
  end,
}
