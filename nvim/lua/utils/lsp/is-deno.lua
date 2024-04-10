local package_path = (...):match("(.-)[^%.]+$")

local _is = nil

---@return boolean
return function()
  if _is ~= nil then
    return _is
  end

  local Path = require("plenary.path")
  local project_root = require(package_path .. ".get-project-root")()
  local deno_root = require("lspconfig.util").root_pattern(
    "deno.json",
    "deno.jsonc"
  )(vim.uv.cwd())

  if not deno_root then
    return false
  end

  if not project_root then
    return true
  end

  return string.sub(Path:new(deno_root):make_relative(project_root), 1, 1)
    ~= "/"
end
