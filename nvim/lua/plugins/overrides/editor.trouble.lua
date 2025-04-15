---@type LazySpec
return {
  [1] = "trouble.nvim",
  optional = true,
  opts = {
    icons = {
      -- kinds = vim.deepcopy(LazyVim.config.icons.kinds),
    },
    modes = {
      symbols = {
        auto_open = true,
        ---@type trouble.Window.opts
        win = {
          -- default: 30?
          size = 28,
        },
      },
    },
  },
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "trouble.nvim" },
      },
    },
  },
}
