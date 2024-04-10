local trunc = require("plugins.core.lualine" .. ".utils").trunc

return {
  [1] = "branch",
  fmt = trunc(nil, nil, 80, nil, true),
}
