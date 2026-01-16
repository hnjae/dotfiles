local have_cc = require("lazyvim.util.treesitter").check()

---@type LazySpec[]
return {
  {
    [1] = "mason.nvim",
    optional = true,
    enabled = have_cc,
  },
  {
    [1] = "mason-lspconfig.nvim",
    optional = true,
    enabled = have_cc,
  },
  {
    [1] = "nvim-treesitter",
    optional = true,
    enabled = have_cc,
  },
  {
    [1] = "none-ls.nvim",
    optional = true,
    enabled = false,
  },
  {
    [1] = "nvim-lint",
    optional = true,
    enabled = have_cc, -- mason.nvim 이 안돌아가는 환경에서는 실행 X
  },
}
