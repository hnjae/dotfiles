return {
  sections = {
    lualine_a = {
      require("plugins.ui.lualine.components.mode"),
    },
    lualine_x = {
      require("plugins.ui.lualine.components.noice-search"),
      require("plugins.ui.lualine.components.noice-command"),
    },
    lualine_z = {
      "location",
      require("plugins.ui.lualine.components.progress"),
    },
  },
  inactive_sections = {
    lualine_z = {
      "location",
      require("plugins.ui.lualine.components.progress"),
    },
  },
}
