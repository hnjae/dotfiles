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
    local utils = require("utils")
    local options = {
      icons_enabled = utils.enable_icon,
      theme = require("plugins.ui.lualine.theme"),

      -- NOTE: do not use something like   <2024-03-07>
      component_separators = utils.enable_icon
          and { left = "┃", right = "┃" }
        or { left = "❘", right = "❘" },

      section_separators = { left = "", right = "" },
      disabled_filetypes = {},

      -- When set to true, left sections i.e. 'a','b' and 'c'
      -- can't take over the entire statusline even
      -- if neither of 'x', 'y' or 'z' are present.
      always_divide_middle = true,

      -- enable global statusline (have a single statusline
      -- at bottom of neovim instead of one for  every window).
      globalstatus = true,
    }

    local ret = {
      options = options,
      sections = {
        lualine_a = {
          -- "mode",
          require("plugins.ui.lualine.components.mode-enhanced"),
        },
        lualine_b = {
          require("plugins.ui.lualine.components.branch"),
          require("plugins.ui.lualine.components.diagnostics"),
          {
            [1] = "overseer",
          },
        },
        lualine_c = {
          require("plugins.ui.lualine.components.filename"),
        },
        lualine_x = {
          require("plugins.ui.lualine.components.noice-search"),
          require("plugins.ui.lualine.components.noice-command"),
          require("plugins.ui.lualine.components.lsp-null-ls")(options),
          require("plugins.ui.lualine.components.spell"),
        },
        lualine_y = {
          require("plugins.ui.lualine.components.encoding-fileformat"),
        },
        lualine_z = {
          require("plugins.ui.lualine.components.progress"),
          "location",
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          require("plugins.ui.lualine.components.filename"),
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          "location",
        },
      },
      tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          require("plugins.ui.lualine.components.buffers"),
        },
        lualine_y = {},
        lualine_z = {
          require("plugins.ui.lualine.components.tabs"),
        },
      },
      extensions = {
        -- pre-configured-extensions
        require("plugins.ui.lualine.extensions.help"),
        require("plugins.ui.lualine.extensions.readonly"),
        require("plugins.ui.lualine.extensions.fugitive"),
        require("plugins.ui.lualine.extensions.netrw"),
        require("plugins.ui.lualine.extensions.toggleterm"),
        require("plugins.ui.lualine.extensions.no-filetype"),
        require("plugins.ui.lualine.extensions.minimap"),
        require("plugins.ui.lualine.extensions.trouble"),
        require("plugins.ui.lualine.extensions.oil"),
      },
    }

    -- tabline
    for _, val in ipairs({
      { "y", "nvim-recorder", "plugins.ui.lualine.components.recorder" },
      { "a", "lspsaga.nvim", "plugins.ui.lualine.components.lspsaga" },
    }) do
      if utils.is_plugin(val[2]) then
        table.insert(
          ret.tabline["lualine_" .. val[1]],
          require(val[3])(options)
        )
      end
    end

    return ret
  end,
}
