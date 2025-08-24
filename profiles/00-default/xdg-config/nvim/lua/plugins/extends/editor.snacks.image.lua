---@type  LazySpec
return {
  [1] = "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {
      enabled = true,
      -- your image configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      doc = {
        max_height = 18, -- default 40
      },
      icons = {
        math = "󰪚 ", -- nf-md-calculator_variant
        chart = "󰄧 ", -- nf-md-chart_areaspline
        image = "󰋩 ", -- nf-md-image
      },
    },
  },
}
