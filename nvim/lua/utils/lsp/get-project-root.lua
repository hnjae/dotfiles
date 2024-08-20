local fd =
  require("lspconfig.util").root_pattern(unpack(require("val").root_patterns))

return function()
  return fd(vim.uv.cwd())
end
