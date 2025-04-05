---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("plugins.core.treesitter.languages"):add("fish")
    end,
  },
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft.fish = { "fish_indent" }
    end,
  },
  {
    [1] = "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require("null-ls")
      -- table.insert(opts.sources, source)
      -- return vim.tbl_deep_extend("keep", opts, {
      --   formatters_by_ft = {
      --     fish = { "fish_indent" },
      --   },
      -- })

      local source = null_ls.builtins.diagnostics.fish
      if vim.fn.executable("fish") == 1 then
        table.insert(opts.sources, source)
      end
    end,
  },
}
