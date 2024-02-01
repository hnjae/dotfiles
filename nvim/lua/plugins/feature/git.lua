-- NOTE: fugitive does not support git@github.com: syntax <2024-01-02>
local val = require("val")

---@type LazySpec
return {
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
  keys = {
    {
      [1] = val.prefix.git .. val.map_keyword.git,
      [2] = "<cmd>vert G<CR>",
      desc = "open-fugitive",
    },
    { [1] = val.prefix.git .. "l", [2] = "<cmd>tab Gclog<CR>", desc = "log" },
    {
      [1] = val.prefix.git .. "c",
      [2] = "<cmd>G commit<CR>",
      desc = "commit",
    },
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
}

-- {
--   [1] = "sindrets/diffview.nvim",
--   enabled = false,
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--   },
-- },
