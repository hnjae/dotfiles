---@type LazySpec[]
return {
  {
    [1] = "nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        zsh = { "zsh" },
      },
    },
  },
}
