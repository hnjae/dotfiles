---@type LazySpec[]
return {
  {
    [1] = "sindrets/diffview.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    [1] = "TimUntersberger/neogit",
    enabled = true,
    lazy = true,
    opts = {},
    cmd = {
      "Neogit",
      "NeogitResetState",
    },
  },
}
