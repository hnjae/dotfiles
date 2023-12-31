return {
  [1] = "HiPhish/rainbow-delimiters.nvim",
  url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
  lazy = true,
  event = { "BufNewFile", "BufReadPost" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    highlight = {
      "Normal",
      "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
      "RainbowDelimiterRed",
    },
  },
  main = "rainbow-delimiters.setup",
}
