local e = require("utils").use_icons
local icons = require("globals").icons.signs
local opts = {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = e and icons.error .. " " or "E",
      [vim.diagnostic.severity.WARN] = e and icons.warn .. " " or "W",
      [vim.diagnostic.severity.INFO] = e and icons.info .. " " or "I",
      [vim.diagnostic.severity.HINT] = e and icons.hint .. " " or "H",
    },
  },
}

vim.diagnostic.config(opts)
