local val = require("val")

---@type LazySpec
return {
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
  },
  keys = {
    {
      [1] = val.prefix.git .. val.map_keyword.git,
      [2] = "<cmd>Git<CR>",
      desc = "open-fugitive",
    },
    {
      [1] = val.prefix.git .. string.upper(val.map_keyword.git),
      [2] = "<cmd>tab Git<CR>",
      desc = "open-fugitive-in-new-tab",
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
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      ---@param opts myLualineOpts
      opts = function(_, opts)
        local icons = require("val").icons
        local icon = icons.git

        require("state.lualine-ft-data"):add({
          fugitive = { display_name = "Fugitive", icon = icon },
        })

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

        if not opts.extensions then
          opts.extensions = {}
        end

        table.insert(
          opts.extensions,
          vim.tbl_deep_extend(
            "keep",
            require("val.plugins.lualine").__get_basic_layout(),
            extension
          )
        )
      end,
    },
  },
}
