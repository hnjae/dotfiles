-- help: lualine-tabs-component-options

local M = {
  [1] = "tabs",
  -- mode = 0, -- shows tab_nr
  mode = 2, -- shows tab_nr + tab_name
  separator = { left = "", right = "" },
  draw_empty = false,
  -- use_mode_colors = true,
  -- fmt = function(name, context)
}

local def_hl_a = vim.api.nvim_get_hl(0, { name = "lualine_a_normal" })
local def_hl_i = vim.api.nvim_get_hl(0, { name = "lualine_a_inactive" })
if not (def_hl_a.fg == def_hl_i.fg and def_hl_a.bg == def_hl_i.bg) then
  for _, hls in ipairs({
    { "TablineSel", "Tabline" },
  }) do
    if vim.fn.hlexists(hls[1]) == 1 and vim.fn.hlexists(hls[2]) == 1 then
      M.tabs_color = {
        active = hls[1],
        inactive = hls[2],
      }
      break
    end
  end
end

return M
