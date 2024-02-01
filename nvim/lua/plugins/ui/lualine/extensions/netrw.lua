local modules = require("lualine_require").lazy_require({
  lspconfig = "lspconfig",
  Path = "plenary.path",
})
local icon = require("plugins.ui.lualine.utils").icons.extension .. " "
local icon_project = require("plugins.ui.lualine.utils").icons.project .. " "

local find_project_root =
  modules.lspconfig.util.root_pattern(unpack(require("val").root_patterns))

local name = function()
  local project_root = find_project_root(vim.b.netrw_curdir)

  if project_root ~= nil then
    return icon_project
      .. modules.Path:new(vim.b.netrw_curdir):make_relative(project_root)
  end

  return icon .. vim.fn.fnamemodify(vim.b.netrw_curdir, ":~")
end

local extension = {
  sections = { lualine_c = { name } },
  inactive_sections = { lualine_c = { name } },
  filetypes = {
    "netrw",
  },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  extension
)
