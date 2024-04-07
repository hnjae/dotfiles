return {
  sections = {
    lualine_a = {
      require("plugins.ui.lualine.components.mode-enhanced"),
    },
    lualine_x = {
      require("plugins.ui.lualine.components.noice-search"),
      require("plugins.ui.lualine.components.noice-command"),
    },
    lualine_z = {
      require("plugins.ui.lualine.components.progress"),
      "location",
    },
  },
  inactive_sections = {
    lualine_z = {
      "location",
    },
  },
}
