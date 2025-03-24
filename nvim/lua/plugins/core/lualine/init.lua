-- local package_path = (...) -- "plugins.core.lualine"
-- NOTE: Above Does not works after lazy.nvim update <2024-07-09>
local package_path = "plugins.core.lualine"

return {
  [1] = "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  enabled = true,
  cond = not vim.g.vscode,
  lazy = true,
  event = "UiEnter",
  ---@param opts myLualineOpts
  opts = function(_, opts)
    -- NOTE: function 으로 랩핑해야, vim.g.colors_name 을 참조할 수 있음. <2023-12-12>
    local utils = require("utils")

    opts.options = vim.tbl_deep_extend(
      "keep",
      require("val.plugins.lualine").options,
      (opts.options and opts.options or {}),
      {
        icons_enabled = utils.enable_icon,
        theme = require(package_path .. ".theme").get(),

        -- NOTE: do not use something like   <2024-03-07>
        -- component_separators = utils.enable_icon
        --     and { left = "", right = "" }
        --   or { left = "❘", right = "❘" },

        component_separators = utils.enable_icon
            and { left = "|", right = "|" }
          or { left = "┃", right = "┃" },
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        section_separators = "",

        disabled_filetypes = {},

        -- When set to true, left sections i.e. 'a','b' and 'c'
        -- can't take over the entire statusline even
        -- if neither of 'x', 'y' or 'z' are present.
        always_divide_middle = true,
      }
    )

    local lualine_components = {}
    lualine_components.sections = {
      lualine_a = {
        require(package_path .. ".components.mode-enhanced"),
      },
      lualine_b = {
        require(package_path .. ".components.branch"),
        require(package_path .. ".components.diagnostics"),
      },
      lualine_c = {
        require(package_path .. ".components.filename"),
      },
      lualine_x = {},
      lualine_y = {
        {
          component = require(package_path .. ".components.spell"),
          priority = 90,
        },
        {
          component = require(
            package_path .. ".components.encoding-fileformat"
          ),
          priority = 100,
        },
      },
      lualine_z = {
        require(package_path .. ".components.progress"),
        "location",
      },
    }
    lualine_components.inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        require(package_path .. ".components.filename"),
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        "location",
      },
    }
    lualine_components.tabline = {
      lualine_a = {
        require(package_path .. ".components.buffers"),
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        require(package_path .. ".components.tabs"),
      },
    }

    for part_name, sections in pairs(lualine_components) do
      if not opts[part_name] then
        opts[part_name] = {}
      end
      for section_name, components in pairs(sections) do
        if not opts[part_name][section_name] then
          opts[part_name][section_name] = {}
        end
        vim.list_extend(opts[part_name][section_name], components)
      end
    end

    if not opts.extensions then
      opts.extensions = {}
    end
    vim.list_extend(opts.extensions, {
      require(package_path .. ".extensions.help"),
      require(package_path .. ".extensions.readonly"),
      require(package_path .. ".extensions.netrw"),
      require(package_path .. ".extensions.no-filetype"),
    })
  end,
  ---@param opts myLualineOpts
  config = function(_, opts)
    for _, upper_section in ipairs({ "sections", "tabline" }) do
      for _, section in ipairs({ "a", "b", "c", "x", "y", "z" }) do
        local parts = opts[upper_section]
        local parts_sub = string.format("lualine_%s", section)

        table.sort(parts[parts_sub], function(a, b)
          return (a.priority and a.priority or 50)
            < (b.priority and b.priority or 50)
        end)

        local empty = {}
        for _, val in ipairs(parts[parts_sub]) do
          if val.component then
            table.insert(empty, val.component)
          else
            table.insert(empty, val)
          end
        end

        parts[parts_sub] = empty
      end
    end

    -- opts.tabline = {}
    -- opts.inactive_winbar = {}
    -- opts.extensions = {}
    -- opts.sections = {}
    -- opts.sections = {
    --   -- lualine_a = { "mode" },
    --   -- lualine_b = { "branch", "diff", "diagnostics" },
    --   -- lualine_c = { "filename" },
    --   -- lualine_x = { "encoding", "fileformat", "filetype" },
    --   -- lualine_y = { "progress" },
    --   lualine_z = { "location" },
    -- }
    -- opts.sections = {}
    -- opts.sections.lualine_a = {}
    -- opts.sections.lualine_b = {}
    -- opts.sections.lualine_c = {}
    -- opts.sections.lualine_x = {}
    -- opts.sections.lualine_y = {}
    -- opts.sections.lualine_z = {}
    require("lualine").setup(opts)
  end,
}
