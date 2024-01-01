local modules = require("lualine_require").lazy_require({
  noice = "noice",
})

return {
  [1] = modules.noice.api.status.search.get,
  cond = modules.noice.api.status.search.has,
  color = { fg = "#ff9e64" },
}
