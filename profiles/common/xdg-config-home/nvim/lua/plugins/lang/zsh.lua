---@type LazySpec[]
return {
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters = {
        shfmt_zsh = {
          command = "shfmt",
          args = function(_, ctx)
            local args = { "--language-dialect=zsh", "--filename", "$FILENAME" }

            if vim.bo[ctx.buf].expandtab then
              vim.list_extend(args, { "--indent", ctx.shiftwidth })
            end

            return args
          end,
        },
      },
      formatters_by_ft = {
        zsh = { "shfmt_zsh" },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "shfmt" } },
      },
    },
  },
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
