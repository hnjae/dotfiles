return {
  sections = {
    lualine_a = {
      require("plugins.core.lualine.components.mode-enhanced"),
    },
    lualine_x = {},
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
