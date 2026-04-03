---@type LazySpec[]
return {
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
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
      {
        [1] = "conform.nvim",
        optional = true,
        opts = function()
          --[[
          NOTE:

          ## conform 에서 `shfmt` 동작 2025-07-19

          - editorconfig 가 있으면 별도로 shiftwidth 무시. editorconfig 가 없으면 shiftwidth 적용
          - 이론상 `shfmt` 가 editorconfig 를 잘 해석해야하는데 그렇지 않음.
            - e.g.) `[*.sh]` 설정이 없고, `[*]` 아래에서 `indent_size = 2` 로 설정되었다면, 이게 적용되지 않음.

          어차피 nvim 에서 editrconfig 를 해석하고 있으므로, `shfmt` 에서는 shiftwidth 설정만 적용하도록 함.
        ]]
          local shfmt = require("conform.formatters.shfmt")
          shfmt.args = function(_, ctx)
            local args = { "-filename", "$FILENAME" }

            if vim.bo[ctx.buf].expandtab then
              vim.list_extend(args, { "-i", ctx.shiftwidth })
            end

            return args
          end
        end,
      },
    },
  },
  {
    [1] = "nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "shellcheck" } },
      },
    },
  },
}
