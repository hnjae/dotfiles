---@type LazySpec
return {
  [1] = "lewis6991/satellite.nvim",
  main = "satellite",
  cond = vim.fn.has("nvim-0.10") == 1,
  lazy = false,
  opts = {
    excluded_filetypes = {
      "fugitive",
      "nerdtree",
      "tagbar",
      "fzf",
      "TelescopePrompt",
      "OverseerList",
      "Outline",
      "toggleterm",
      "noice",
      "notify",
      "NvimTree",
      "alpha",
      "lazy",
      "startify",
      "netrw",
      "vim-plug",
      "oil",
      -- "help",
    },
    -- gitsigns = {
    --   enable = true,
    -- },
    -- marks = {
    --   enable = true,
    -- },
    -- diagnostic = {
    --   enable = true,
    -- },
  },
  -- config = function(_, opts)
  --   require("satellite").setup(opts)
  -- end,
}
