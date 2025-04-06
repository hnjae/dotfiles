---@type LazySpec[]
return {
  {
    [1] = "zbirenbaum/copilot-cmp",
    optional = true,
    enabled = false,
  },
  { [1] = "giuxtaposition/blink-cmp-copilot" },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    enabled = false,
    event = "VeryLazy",
  },
}
