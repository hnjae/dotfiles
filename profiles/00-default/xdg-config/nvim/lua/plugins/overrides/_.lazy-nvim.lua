local have_cc = require("lazyvim.util.treesitter").check()

---@type LazySpec[]
return {
  {
    [1] = "lazy.nvim",
    optional = true,
    opts = {
      rocks = {
        enable = false,
      },
    },
  },
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
}
