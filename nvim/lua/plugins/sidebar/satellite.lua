-- NOTE: <2024-07-26> 딱히 효용성 잘 모르겠음

---@type LazySpec
return {
  [1] = "lewis6991/satellite.nvim",
  main = "satellite",
  enabled = false,
  -- lazy = true,
  cond = vim.fn.has("nvim-0.10") == 1,
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
