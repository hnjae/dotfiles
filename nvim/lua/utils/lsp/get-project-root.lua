local root = nil
return function()
  if root then
    return root
  end
  root = require("lspconfig.util").root_pattern(
    unpack(require("val").root_patterns)
  )(vim.uv.cwd())
  return root
end
