-- nvim-lint does not handle cwd

---@type LazySpec
return {
  [1] = "none-ls.nvim",
  optional = true,
  opts = function(_, opts)
    -- DO NOT USE mason.nvim since `mypy` requires to read library stub

    if vim.fn.executable("mypy") == 1 then
      local nls = require("null-ls")

      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.mypy,
      })
    end
  end,
}
