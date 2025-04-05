---@type LazySpec[]
return {
  {
    [1] = "direnv/direnv.vim",
    lazy = false,
    enabled = true,
    init = function()
      vim.g.direnv_auto = 0
      vim.g.direnv_silent_load = 0
    end,
    config = function()
      -- these could not be deleted
      -- for _, command in ipairs({ "DirenvExport", "EditDirenvrc", "EditEnvrc" }) do
      --   vim.api.nvim_del_user_command(command)
      -- end
    end,
  },
}
