---@type LazySpec
return {
  [1] = "anuvyklack/windows.nvim",
  event = "WinNew",
  lazy = true,
  dependencies = {
    { "anuvyklack/middleclass" },
    { [1] = "anuvyklack/animation.nvim", enabled = false },
  },
  keys = { { "<leader>m", "<cmd>WindowsMaximize<cr>", desc = "Zoom" } },
  opts = {
    ignore = {
      buftype = {
        "picker",
        "prompt",
        "nofile",
        "nowrite",
        "quickfix",
        "terminal",
      },
      filetype = {
        "notify",
        "noice",
        "TelescopePrompt",
        "lazy",
        "tagbar",
        "fzf",
        "OverseerList",
        "Outline",
        "toggleterm",
        "NvimTree",
        "alpha",
      },
    },
    animation = {
      enable = false,
    },
  },
  -- config = function()
  --   vim.o.winwidth = 5
  --   vim.o.equalalways = false
  --   require("windows").setup({
  --     animation = { enable = false, duration = 150 },
  --   })
  -- end,
}
