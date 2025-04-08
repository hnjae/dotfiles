---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      ts_ls = {
        enabled = true,
      },
    },
    setup = {
      ts_ls = function(_, opts)
        -- do nothing
      end,
    },
  },
}
