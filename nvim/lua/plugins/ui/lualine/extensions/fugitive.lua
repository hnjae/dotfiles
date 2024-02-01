local name = function()
  return require("plugins.ui.lualine.utils").icons.git_branch
    .. " "
    .. vim.fn.FugitiveHead()
end

local fugitive = {
  sections = {
    lualine_c = { { name } },
  },
  inactive_sections = {
    lualine_c = { { name } },
  },
  filetypes = { "fugitive" },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  fugitive
)
