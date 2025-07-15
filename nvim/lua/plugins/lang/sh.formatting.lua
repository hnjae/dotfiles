---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      -- NOTE: conform 에서 shfmt 는 .editorconfig 를 vi-modeline 보다 우선함. <2025-07-15>
      sh = {
        [1] = "shellharden",
        [2] = "shellcheck",
        [3] = "shfmt",
        stop_after_first = false,
      },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "shellharden", "shellcheck", "shfmt" } },
    },
  },
}
