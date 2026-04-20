local M = {}
local registry_specs

---@param name string
---@return string
local function normalize_name(name)
  return (name:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1"))
end

local function has_exec(cmd)
  return vim.fn.executable(cmd) == 1
end

local function has_pip()
  if vim.fn.executable("python3") ~= 1 then
    return false
  end
  vim.fn.system({ "python3", "-m", "pip", "--version" })
  return vim.v.shell_error == 0
end

---@param pkg_name string
---@return string[]
function M.missing_prerequisites(pkg_name)
  pkg_name = normalize_name(pkg_name)
  if not registry_specs then
    local registry_path = vim.fn.stdpath("data")
      .. "/mason/registries/github/mason-org/mason-registry/registry.json"
    local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(registry_path), "\n"))
    registry_specs = {}
    if ok and type(decoded) == "table" then
      for _, spec in ipairs(decoded) do
        if type(spec) == "table" and type(spec.name) == "string" then
          registry_specs[spec.name] = spec
        end
      end
    end
  end

  local spec = registry_specs[pkg_name]
  if not spec then
    local ok, pkg = pcall(require("mason-registry").get_package, pkg_name)
    if ok then
      spec = pkg.spec
    end
  end
  if not spec then
    return {}
  end

  local source = spec.source or {}
  local source_id = source.id or ""

  local missing = {}
  local seen = {}
  local function require_exec(cmd)
    if not seen[cmd] and not has_exec(cmd) then
      seen[cmd] = true
      missing[#missing + 1] = cmd
    end
  end

  if source_id:match("^pkg:npm/") then
    require_exec("npm")
  elseif source_id:match("^pkg:golang/") then
    require_exec("go")
  elseif source_id:match("^pkg:cargo/") then
    require_exec("cargo")
  elseif source_id:match("^pkg:pypi/") then
    if not has_pip() then
      missing[#missing + 1] = "python3 -m pip"
    end
  elseif source_id:match("^pkg:openvsx/") then
    require_exec("unzip")
  end

  local assets = source.asset
  if type(assets) ~= "table" then
    assets = assets and { assets } or {}
  end
  for _, asset in ipairs(assets) do
    local file = type(asset) == "table" and asset.file or asset
    if type(file) == "string" then
      if file:match("%.zip$") or file:match("%.vsix$") then
        require_exec("unzip")
      elseif file:match("%.tar%.gz$") then
        require_exec("tar")
        require_exec("gzip")
      elseif file:match("%.gz$") then
        require_exec("gzip")
      end
    end
  end

  return missing
end

---@param opts MasonSettings | { ensure_installed?: string[] }
---@return string[]
function M.filter_ensure_installed(opts)
  local ensure_installed = opts.ensure_installed or {}
  local filtered = {}
  local skipped = {}
  local seen = {}

  for _, pkg_name in ipairs(ensure_installed) do
    pkg_name = normalize_name(pkg_name)
    if not seen[pkg_name] then
      seen[pkg_name] = true
      local missing = M.missing_prerequisites(pkg_name)
      if #missing == 0 then
        filtered[#filtered + 1] = pkg_name
      else
        skipped[#skipped + 1] = ("%s (%s)"):format(pkg_name, table.concat(missing, ", "))
      end
    end
  end

  opts.ensure_installed = filtered
  return skipped
end

---@param title string
---@param prefix string
---@param items string[]
function M.notify_skipped(title, prefix, items)
  if #items == 0 then
    return
  end

  vim.schedule(function()
    vim.notify_once(prefix .. table.concat(items, ", "), vim.log.levels.INFO, { title = title })
  end)
end

return M
