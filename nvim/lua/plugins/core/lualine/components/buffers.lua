-- help: lualine-buffers-component-options

local M = {
  [1] = "buffers",
  mode = 0, -- show buffer name
  draw_empty = true,
  show_filename_only = true,
  -- M.fmt 에서 처리
  -- filetype_names = require("plugins.core.lualine.utils.filetype-names"),
  separator = { left = "", right = "" },
  icons_enabled = false,
  symbols = {
    modified = " ", -- nf-cod-circle_filled
    -- NOTE: what is alternate_file? <2024-04-06>
    -- most-recent file (maybe) access using :e# or :bp
    -- :h alternate-file
    alternate_file = "# ",
    -- directory = "",
  },
}

if not require("utils").use_icons then
  M.symbols = nil
end

for _, hls in ipairs({
  { "PmenuSel", "Pmenu" },
  { "BufferCurrent", "BufferInactive" },
  { "BufferLineIndicatorSelected", "BufferLineFill" },
  { "TelescopeSelection" },
}) do
  if vim.fn.hlexists(hls[1]) == 1 then
    M.buffers_color = {
      active = hls[1],
    }
    break
  end
end

---@type fun(name: string, context: object): string
M.fmt = require("plugins.core.lualine.utils.filename-fmt")

return M
