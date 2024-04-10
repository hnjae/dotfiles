return {
  sections = {
    lualine_a = {
      require("plugins.core.lualine.components.mode-enhanced"),
    },
    lualine_x = {
      require("plugins.core.lualine.components.noice-search"),
      require("plugins.core.lualine.components.noice-command"),
    },
    lualine_z = {
      require("plugins.core.lualine.components.progress"),
      "location",
    },
  },
  inactive_sections = {
    lualine_z = {
      "location",
    },
  },
}
