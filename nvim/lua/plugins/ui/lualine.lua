return {
  [1] = "nvim-lualine/lualine.nvim",
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
        theme = require("plugins.ui.lualine.theme"),
        component_separators = os.getenv("XDG_SESSION_TYPE") ~= "tty" and { left = "┃", right = "┃" }
            or { left = "❘", right = "❘" },
        -- section_separators = { left = "", right = "" },
        -- section_separators = os.getenv("XDG_SESSION_TYPE") ~= "tty" and { left = "", right = "" }
        section_separators = os.getenv("XDG_SESSION_TYPE") ~= "tty" and { left = "█", right = "█" }
            or { left = ">", right = "<" },
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
          require("plugins.ui.lualine.components.mode"),
        },
        lualine_b = {
          "branch",
          require("plugins.ui.lualine.components.diagnostics"),
          -- "diff",
        },
        lualine_c = { "filename" },
        lualine_x = {
          {
            [1] = require("noice").api.status.command.get,
            cond = require("noice").api.status.command.has,
            color = { fg = "#ff9e64" },
          },
          {
            [1] = require("noice").api.status.search.get,
            cond = require("noice").api.status.search.has,
            color = { fg = "#ff9e64" },
          },
          require("plugins.ui.lualine.components.null-ls"),
          require("plugins.ui.lualine.components.lsp"),
          require("plugins.ui.lualine.components.spell"),
        },
        lualine_y = {
          require("plugins.ui.lualine.components.encoding"),
          require("plugins.ui.lualine.components.fileformat"),
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
          require("plugins.ui.lualine.components.luasnip"),
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
          require("plugins.ui.lualine.components.buffers"),
        },
        lualine_z = {
          require("plugins.ui.lualine.components.tabs"),
        },
      },
      extensions = {
        -- pre-configured-extensions
        "quickfix",
        require("plugins.ui.lualine.extensions.help"),
        require("plugins.ui.lualine.extensions.fugitive"),
        require("plugins.ui.lualine.extensions.misc"),
        require("plugins.ui.lualine.extensions.netrw"),
        require("plugins.ui.lualine.extensions.nvimtree"),
      },
    }
    return opts
  end,
}
