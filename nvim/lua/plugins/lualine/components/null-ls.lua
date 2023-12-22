local sources = require("null-ls.sources")

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
  function()
    return table.concat(get_sources(), ", ")
  end,
  icon = "󰟢",
  cond = function()
    return (next(get_sources()) ~= nil)
  end,
}
