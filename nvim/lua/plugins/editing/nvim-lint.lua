---@type LazySpec
return {
  [1] = "mfussenegger/nvim-lint",
  lazy = true,
  enabled = false,
  event = "VeryLazy",
  main = "lint",
  opts = {},
  config = function(plugin, opts)
    local lint = require(plugin.main)
    -- lint.setup(opts)

    lint.linters.codespell =
      vim.tbl_extend("force", require("lint.linters.codespell"), {
        args = {
          "-I",
          require("plenary.path"):new(
            vim.fn.stdpath("config"),
            "/spell/en.utf-8.add"
          ).filename,
          "--",
        },
      })

    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        -- try_lint without arguments runs the linters defined in `linters_by_ft`
        -- for the current filetype
        -- lint.try_lint()

        -- You can call `try_lint` with a linter name or a list of names to always
        -- run specific linters, independent of the `linters_by_ft` configuration
        lint.try_lint("codespell")
      end,
    })
  end,
}
