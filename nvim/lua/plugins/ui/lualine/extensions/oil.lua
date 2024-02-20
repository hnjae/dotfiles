local modules = require("lualine_require").lazy_require({
  oil = "oil",
  lspconfig = "lspconfig",
  Path = "plenary.path",
})
local icon = require("plugins.ui.lualine.utils").icons.extension .. " "
local find_project_root =
  modules.lspconfig.util.root_pattern(unpack(require("val").root_patterns))

local name = function()
  local cur_dir = modules.oil.get_current_dir()
  local project_root = find_project_root(cur_dir)

  if project_root ~= nil then
    return icon .. modules.Path:new(cur_dir):make_relative(project_root)
  end

  return icon .. vim.fn.fnamemodify(cur_dir, ":~")
end

local extension = {
  sections = {
    lualine_c = { { name } },
  },
  inactive_sections = {
    lualine_c = { { name } },
  },
  filetypes = { "oil" },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  extension
)
