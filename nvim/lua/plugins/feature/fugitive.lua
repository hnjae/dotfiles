local val = require("val")

---@type LazySpec[]
return {
  {
    [1] = "tpope/vim-fugitive",
    dependencies = {
      { [1] = "tpope/vim-rhubarb" },
    },
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
      "Browse",
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
    init = function() end,
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
  {
    [1] = "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local get_icon = require("plugins.core.lualine.utils.get-icon")
      local icon = get_icon(nil, "fugitive")

      local name
      if require("utils").enable_icon then
        name = function()
          return string.format("%s %s", icon, vim.fn.FugitiveHead())
        end
      else
        name = vim.fn.FugitiveHead
      end

      local extension = {
        sections = {
          lualine_c = { { name } },
        },
        inactive_sections = {
          lualine_c = { { name } },
        },
        filetypes = { "fugitive" },
      }

      table.insert(
        opts.extensions,
        vim.tbl_deep_extend(
          "keep",
          opts.__extension_basic,
          require("plugins.core.lualine.extensions.basic"),
          extension
        )
      )
    end,
  },
}

-- {
--   [1] = "sindrets/diffview.nvim",
--   enabled = false,
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--   },
-- },
