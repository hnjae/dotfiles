---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  opts = {
    -- TODO: shfmt 가 sw 옵션을 따르게 하기 <2025-07-05>
    formatters_by_ft = {
      sh = {
        [1] = "shellharden",
        [2] = "shellcheck",
        -- [3] = "shfmt",
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
