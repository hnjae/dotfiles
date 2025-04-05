local fd =
  require("lspconfig.util").root_pattern(unpack(require("globals").root_patterns))

return function()
  return fd(vim.uv.cwd())
end
