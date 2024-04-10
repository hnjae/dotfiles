local trunc = require("plugins.core.lualine.utils").trunc

return {
  [1] = "progress",
  fmt = trunc(nil, nil, 120, nil, false),
}
