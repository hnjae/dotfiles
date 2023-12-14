return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  enabled = true,
  lazy = false,
  priority = 1, -- default 50
  opts = function()
    -- NOTE: function 으로 랩핑해야, vim.g.colors_name 을 참조할 수 있음. <2023-12-12>
    local opts = {
      options = {
        icons_enabled = true,
        theme = require("plugins.lualine.theme"),
        -- component_separators = { left = "¦", right = "¦" },
        -- component_separators = { left = "❘", right = "❘" },
        component_separators = { left = "𑗅", right = "𑗅" },
        -- section_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},     -- Filetypes to disable lualine for.
        always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
        -- can't take over the entire statusline even
        -- if neither of 'x', 'y' or 'z' are present.
        globalstatus = false, -- enable global statusline (have a single statusline
        -- at bottom of neovim instead of one for  every window).
        -- This feature is only available in neovim 0.7 and higher.
      },
      sections = {
        lualine_a = {
          require("plugins.lualine.components.mode"),
        },
        lualine_b = { "diagnostics", "branch", "diff" },
        lualine_c = { "filename" },
        lualine_x = {
          require("plugins.lualine.components.null-ls"),
          require("plugins.lualine.components.lsp"),
          require("plugins.lualine.components.spell"),
        },
        lualine_y = {
          require("plugins.lualine.components.encoding"),
          require("plugins.lualine.components.fileformat"),
          "filetype",
        },
        lualine_z = { "location", "progress" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        -- lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = {
          require("plugins.lualine.components.tabs"),
        },
        lualine_c = {
          require("plugins.lualine.components.buffers"),
        },
        lualine_z = {
          require("plugins.lualine.components.luasnip"),
        },
      },
      extensions = {
        -- pre-configured-extensions
        "quickfix",
        require("plugins.lualine.extensions.help"),
        require("plugins.lualine.extensions.fugitive"),
        require("plugins.lualine.extensions.misc"),
        require("plugins.lualine.extensions.netrw"),
        require("plugins.lualine.extensions.nvimtree"),
      },
    }
    return opts
  end,
}
