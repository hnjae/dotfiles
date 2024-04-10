-- help: lualine-buffers-component-options

local M = {
  [1] = "buffers",
  mode = 0, -- show buffer name
  draw_empty = true,
  show_filename_only = true,
  -- M.fmt 에서 처리
  -- filetype_names = require("plugins.core.lualine.utils.filetype-names"),
  icons_enabled = false,
  symbols = {
    modified = " ", -- nf-cod-circle_filled
    -- NOTE: what is alternate_file?  <2024-04-06>
    -- most-recent file (maybe) access using :e# or :bp
    -- :h alternate-file
    alternate_file = "# ",
    -- directory = "",
  },
}

if not require("utils").enable_icon then
  M.symbols = nil
end

-- local def_hl_a = vim.api.nvim_get_hl(0, { name = "lualine_c_normal" })
-- local def_hl_i = vim.api.nvim_get_hl(0, { name = "lualine_c_inactive" })
-- if not (def_hl_a.fg == def_hl_i.fg and def_hl_a.bg == def_hl_i.bg) then
for _, hls in ipairs({
  { "PmenuSel", "Pmenu" },
  { "BufferCurrent", "BufferInactive" },
  { "BufferLineIndicatorSelected", "BufferLineFill" },
  { "TelescopeSelection" },
  -- { "TabLineSel", "TabLine" },
}) do
  -- if vim.fn.hlexists(hls[1]) == 1 and vim.fn.hlexists(hls[2]) == 1 then
  if vim.fn.hlexists(hls[1]) == 1 then
    M.buffers_color = {
      active = hls[1],
      -- inactive = hls[2],
    }
    break
  end
end
-- end

---@type fun(name: string, context: object): string
M.fmt = require("plugins.core.lualine.utils.filename-fmt")

return M
