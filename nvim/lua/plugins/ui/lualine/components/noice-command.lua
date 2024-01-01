local modules = require("lualine_require").lazy_require({
  noice = "noice",
})

return {
  [1] = modules.noice.api.status.command.get,
  cond = modules.noice.api.status.command.has,
  -- fmt = trunc(nil, nil, 90, nil, false),
  color = { fg = "#ff9e64" },
}
