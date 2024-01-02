---@type LazySpec[]
return {
  {
    [1] = "sindrets/diffview.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    [1] = "TimUntersberger/neogit",
    enabled = false,
    lazy = true,
    opts = {},
    cmd = {
      "Neogit",
      "NeogitResetState",
    },
  },
  {
    -- NOTE: fugitive does not support git@github.com: syntax <2024-01-02>
    [1] = "tpope/vim-fugitive",
    lazy = true,
    enabled = true,
    cmd = {
      "G",
      "Git",
      "Ggrep",
      "Gclog",
      "Gllog",
      "Gcd",
      "Glcd",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gpedit",
      "Gdrop",
      "Gread",
      "Gwrite",
      "Gwq",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Ghdiffsplit",
      "GMove",
      "GRename",
      "GDelete",
      "GRemove",
      "GUnlink",
      "GBrowse",
    },
    config = function()
      -- remove(delete) all deprecated commands
      for _, command in pairs({
        "Gremove",
        "Gdelete",
        "Gmove",
        "Grename",
        "Gbrowse",
      }) do
        vim.api.nvim_del_user_command(command)
      end
    end,
  },
}
