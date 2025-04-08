---@type LazySpec
return {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local get_theme = function()
      --[[
        NOTE: `theme` 에는 다음 항목이 있어야함. <2023-12-11>
          - command
          - visual
          - replace
          - insert
          - normal
          - inactive
          - terminal
      ]]
      if vim.g.colors_name == nil then
        return "auto"
      end

      local is_theme, theme = pcall(require, "lualine.themes." .. vim.g.colors_name)

      if not is_theme then
        return "auto"
      end

      -- terminal, command 가 없는 theme 이 많다.
      theme.terminal = theme.terminal or theme.insert
      theme.command = theme.command or theme.insert

      return theme
    end

    --  remove progress/location
    opts.sections.lualine_y = {}

    -- disable clock time
    opts.sections.lualine_z = {
      { "progress", separator = " ", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    }

    -- define theme
    opts.options.theme = get_theme()
    opts.options.component_separators = { left = "|", right = "|" }
    opts.options.section_separators = ""

    -- When set to true, left sections i.e. 'a','b' and 'c'
    -- can't take over the entire statusline even
    -- if neither of 'x', 'y' or 'z' are present.
    opts.options.always_devide_middle = true
  end,
}
