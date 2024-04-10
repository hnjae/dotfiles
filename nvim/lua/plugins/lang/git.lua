---@type LazySpec[]
return {
  {
    [1] = "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { [1] = "petertriho/cmp-git", dependencies = "nvim-lua/plenary.nvim" },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "LazyLoad",
      --   callback = function(event)
      --     if event.data == "nvim-cmp" then
      --       -- cmp.setup.filetype("gitcommit",
      --       local cmp = require("cmp")
      --       cmp.setup.filetype("gitcommit", {
      --         sources = cmp.config.sources({
      --           { name = "cmp_git" },
      --         }),
      --       })
      --       -- )
      --     end
      --   end,
      -- })

      table.insert(opts.sources, { name = "cmp_git", group_index = 1 })
      -- return opts
    end,
  },
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add(
        "gitignore",
        "gitcommit",
        "git_config",
        "gitattributes",
        "git_rebase",
        "git_config"
      )
    end,
  },
}
