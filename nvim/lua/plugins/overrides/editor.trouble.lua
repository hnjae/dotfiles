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
        auto_open = false,
        ---@type trouble.Window.opts
        win = {
          -- default: 30?
          size = 26,
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
