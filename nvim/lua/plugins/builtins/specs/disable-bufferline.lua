---@type LazySpec[]
return {
  {
    [1] = "akinsho/bufferline.nvim",
    optional = true,
    enabled = false,
  },
  {
    [1] = "nvim-lualine/lualine.nvim",
    optional = true,
    opts = {
      tabline = {
        lualine_a = {
          "buffers",
        },
        lualine_z = {
          { [1] = "tabs", mode = 2 },
        },
      },
    },
  },
}
