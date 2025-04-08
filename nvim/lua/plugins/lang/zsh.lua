---@type LazySpec[]
return {
  {
    [1] = "nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        zsh = { "shellcheck", "zsh", "shellharden" },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "shellcheck", "shellharden" } },
      },
    },
  },
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        zsh = { [1] = "shellcheck", [2] = "beautysh", stop_after_first = false },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "shellcheck", "beautysh" } },
      },
    },
  },
}
