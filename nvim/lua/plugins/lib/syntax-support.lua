-- NOTE: syntax won't work if lazy=true

---@type LazySpec[]
return {

  -- NOTE: Makes vim slow <?>
  -- { "sheerun/vim-polyglot", lazy = false },

  -- OUT OF BOX SUPPORTED
  -- { [1] = "udalov/kotlin-vim", lazy = false },
  -- { [1] = "LnL7/vim-nix", lazy = false },

  { [1] = "imsnif/kdl.vim", lazy = false },
  { [1] = "mustache/vim-mustache-handlebars", lazy = false },
  { [1] = "jxnblk/vim-mdx-js", lazy = false },
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
