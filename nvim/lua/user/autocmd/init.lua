local M = {}

function M.setup()
  local module_list = {
    'user.autocmd.asciidoc',
    -- 'user.autocmd.event-test',
  }

  for _, module_name in ipairs(module_list) do
    local status, module = pcall(require, module_name)
    if status then
      module.setup()
    end
  end
end

return M
