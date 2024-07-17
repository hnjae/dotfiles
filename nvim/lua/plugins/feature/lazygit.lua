---@type LazySpec
return {
  [1] = "kdheepak/lazygit.nvim",
  lazy = true,
  enabled = false,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function() end,
  specs = {
    {
      [1] = "nvim-telescope/telescope.nvim",
      opts = function()
        require("utils.plugin").on_load("telescope.nvim", function()
          require("telescope").load_extension("lazygit")
        end)
      end,
    },
  },
}
