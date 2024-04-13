local lualine_path = "plugins.core.lualine"

---@type myLualineOpts
return {
  __my_lualine_path = lualine_path,
  __get_basic_layout = function()
    return {
      sections = {
        lualine_a = {
          require(lualine_path .. ".components.mode-enhanced"),
        },
        lualine_x = {
          require(lualine_path .. ".components.noice-search"),
          require(lualine_path .. ".components.noice-command"),
        },
        lualine_z = {
          require(lualine_path .. ".components.progress"),
          "location",
        },
      },
      inactive_sections = {
        lualine_z = {
          "location",
        },
      },
    }
  end,
  -- __basic_layout = "plugins.core.lualine.extensions.basic",
  options = {
    -- enable global statusline (have a single statusline
    -- at bottom of neovim instead of one for  every window).
    globalstatus = true,
  },
}
