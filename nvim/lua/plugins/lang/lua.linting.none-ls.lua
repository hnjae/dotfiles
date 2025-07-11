-- nvim-lint does not handle cwd

---@type LazySpec
return {
  [1] = "none-ls.nvim",
  optional = true,
  opts = function(_, opts)
    local nls = require("null-ls")

    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.diagnostics.selene.with({
        condition = function(utils)
          return utils.root_has_file({ "selene.toml" })
        end,
      }),
    })

    return opts
  end,

  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "selene" } },
    },
  },
}
