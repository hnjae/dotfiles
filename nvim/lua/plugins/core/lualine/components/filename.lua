-- -- :h lualine-filename-component-options
-- local is_lspconfig, lspconfig = pcall(require, "lspconfig")
-- local project_root
-- if is_lspconfig then
--   local find_project_root =
--     lspconfig.util.root_pattern(unpack(require("val").root_patterns))
--   project_root = find_project_root(vim.uv.cwd())
-- else
--   project_root = nil
-- end

local M = {
  [1] = "filename",
  file_status = true,
  newfile_status = true,
  -- path = not project_root and 1,
  path = 1,
  -- cond = function()
  --   if
  --     vim.bo.buftype == "nofile"
  --     and vim.bo.filetype ~= ""
  --     and vim.b[0].did_ftplugin ~= nil
  --   then
  --     -- e.g. preview pane of LspSaga's outline/hover
  --     return false
  --   end
  --
  --   return true
  -- end,
}

---@type fun(filename: string): string
M.fmt = function(filename)
  -- if project_root then
  --   filename = project_root
  --   filename = require("plenary.path")
  --     :new(vim.fn.expand("%:p:h"))
  --     :make_relative(project_root)
  -- end

  -- if ft_names[vim.bo.filetype] then
  --   filename = ft_names[vim.bo.filetype]
  -- end

  -- return "hi"
  return require("plugins.core.lualine.utils.filename-fmt")(filename, {
    bufnr = vim.api.nvim_get_current_buf(),
    buftype = vim.bo.buftype,
    filetype = vim.bo.filetype,
  })
end

return M
