-- local package_path = (...)
local package_path = "plugins.editing.lsp-signature"

local options = {
  cmp = ".cmp",
  noice = ".noice",
  lsp_signature = ".lsp-signature",
}

-- shows popup window about parameter/func
---@type LazySpec|LazySpec[]
return require(package_path .. options.lsp_signature)
