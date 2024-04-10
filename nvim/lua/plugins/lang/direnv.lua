---@type LazySpec[]
return {
  {
    [1] = "direnv/direnv.vim",
    lazy = false,
    enabled = true,
    -- use syntax support only
    init = function()
      vim.g.direnv_auto = 0
      vim.g.direnv_silent_load = 0
    end,
    config = function()
      for _, command in ipairs({ "DirenvExport", "EditDirenvrc", "EditEnvrc" }) do
        vim.api.nvim_del_user_command(command)
      end
    end,
  },
}
