local sources = require("null-ls.sources")

-- TODO: null-ls 가 vim.lsp.get_active_clients({ bufnr = 0 }) 에 있는지 확인 <2023-12-27>
local get_sources = function()
  local names = {}
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  for _, source in ipairs(sources.get_available(filetype)) do
    if not names[source.name] then
      table.insert(names, source.name)
      names[source.name] = true
    end
  end
  return names
end

return {
  [1] = function()
    return table.concat(get_sources(), ", ")
  end,
  icon = "󰟢",
  cond = function()
    return (next(get_sources()) ~= nil)
  end,
}
