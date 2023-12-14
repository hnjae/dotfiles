local sources = require("null-ls.sources")

return {
  function()
    local names = {}
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    for _, source in ipairs(sources.get_available(filetype)) do
      table.insert(names, source.name)
    end

    return table.concat(names, ", ")
  end,
  icon = "󰟢",
  cond = function()
    return (next(sources.get_available(vim.api.nvim_buf_get_option(0, "filetype"))) ~= nil)
  end,
}
