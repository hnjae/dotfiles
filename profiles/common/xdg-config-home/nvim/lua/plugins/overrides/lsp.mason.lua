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

local function missing_prerequisites(pkg_name)
  local ok, pkg = pcall(require("mason-registry").get_package, pkg_name)
  if not ok then
    return {}
  end

  local spec = pkg.spec or {}
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
local function filter_ensure_installed(opts)
  local ensure_installed = opts.ensure_installed or {}
  local filtered = {}
  local skipped = {}
  local seen = {}

  for _, pkg_name in ipairs(ensure_installed) do
    if not seen[pkg_name] then
      seen[pkg_name] = true
      local missing = missing_prerequisites(pkg_name)
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

---@type LazySpec[]
return {
  {
    [1] = "mason.nvim",
    optional = true,
    ---@type MasonSettings
    opts = {
      PATH = "append", -- Mason's bin location is put at the end of PATH
      max_concurrent_installers = 3, -- default: 4
      log_level = vim.log.levels.WARN,
    },
    ---@param opts MasonSettings | { ensure_installed?: string[] }
    config = function(_, opts)
      local skipped = filter_ensure_installed(opts)

      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed or {}) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)

      if #skipped > 0 then
        vim.schedule(function()
          vim.notify_once(
            "Skipping Mason packages with missing prerequisites: " .. table.concat(skipped, ", "),
            vim.log.levels.INFO,
            { title = "mason.nvim" }
          )
        end)
      end
    end,
    specs = {},
  },
  {
    [1] = "mason-lspconfig.nvim",
    optional = true,
    opts = {
      automatic_enable = {
        exclude = { "nil_ls" },
      },
    },
  },
}
