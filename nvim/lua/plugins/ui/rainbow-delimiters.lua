---@type LazySpec
return {
  [1] = "HiPhish/rainbow-delimiters.nvim",
  url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
  lazy = true,
  enabled = true and require("utils").is_treesitter,
  -- NOTE: VeryLaze/VimEnter 은 너무 늦음 <2024-01-04>
  -- event = { "BufNewFile", "BufReadPost" },
  event = { "FileType" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    highlight = {
      -- "Normal",
      -- "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      -- "RainbowDelimiterOrange",
      "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
      "RainbowDelimiterRed",
    },
    -- query = {
    --   [""] = "rainbow-delimiters",
    --   lua = "rainbow-blocks",
    -- },
  },
  main = "rainbow-delimiters.setup",
}
