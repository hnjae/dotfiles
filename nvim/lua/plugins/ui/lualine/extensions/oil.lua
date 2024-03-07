local modules = require("lualine_require").lazy_require({
  oil = "oil",
  lspconfig = "lspconfig",
  Path = "plenary.path",
})

local find_project_root =
  modules.lspconfig.util.root_pattern(unpack(require("val").root_patterns))

local get_name = function()
  local cur_dir = modules.oil.get_current_dir()
  local project_root = find_project_root(cur_dir)

  if project_root ~= nil then
    return modules.Path:new(cur_dir):make_relative(project_root)
  end

  return vim.fn.fnamemodify(cur_dir, ":~")
end

local name
if require("utils").enable_icon then
  local icon = require("plugins.ui.lualine.utils.get-icon")(nil, "oil")
  name = function()
    return string.format("%s %s", icon, get_name())
  end
else
  name = get_name
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
