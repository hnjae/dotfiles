local trunc = require("plugins.ui.lualine.utils").trunc

return {
  [1] = "progress",
  fmt = trunc(nil, nil, 120, nil, false),
}
