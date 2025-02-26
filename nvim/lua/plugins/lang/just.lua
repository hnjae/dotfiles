---@type LazySpec[]
return {
  {
    [1] = "NoahTheDuke/vim-just",
    lazy = true,
    enabled = true, -- just support out-of-the box Neovim 0.11 (current 0.10 2025-02-26)
    ft = { "just" },
  },
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    dependencies = {
      {
        [1] = "IndianBoy42/tree-sitter-just",
        opts = {},
      },
    },
    opts = function()
      require("state.treesitter-langs"):add("just")
    end,
  },
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft.just = { "just" }
    end,
  },
}
