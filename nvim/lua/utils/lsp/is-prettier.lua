local package_path = (...):match("(.-)[^%.]+$")

local _is = nil

---@return boolean
return function()
  if _is ~= nil then
    return _is
  end

  local Path = require("plenary.path")
  local project_root = require(package_path .. ".get-project-root")()
  -- require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
  local prettier_root = require("lspconfig.util").root_pattern(
    "prettier.config.js",
    "prettier.config.mjs",
    "prettier.config.cjs",
    ".prettierrc.js",
    ".prettierrc.mjs",
    ".prettierrc.cjs",
    ".prettierrc",
    ".prettierrc.toml",
    ".prettierrc.json",
    ".prettierrc.json5",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    "package.json"
  )(vim.uv.cwd())

  if not prettier_root then
    return false
  end

  if not project_root then
    return true
  end

  return string.sub(Path:new(prettier_root):make_relative(project_root), 1, 1)
    ~= "/"
end
