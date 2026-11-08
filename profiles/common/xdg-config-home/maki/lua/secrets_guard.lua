-- Block access to secret paths from every tool call.
--
-- `read` and friends never declare a permission scope, so permissions.toml
-- cannot gate them. A `tool.*.input` layer runs before the call, so it
-- covers native tools, MCP tools, and nested calls alike.
--
-- Only the fields that name a target are checked, never the whole input.
-- Scanning every string would refuse an edit that merely mentions a path in
-- its own text, which locks the guard out of its own source and out of any
-- document that describes these paths.

local home = maki.uv.os_homedir()
local xdg_config = maki.uv.os_getenv("XDG_CONFIG_HOME") or (home .. "/.config")

local PROTECTED_DIRS = {
  home .. "/.ssh",
  xdg_config .. "/sops",
}

-- Fields that name a path the tool will open, create, or search.
local PATH_FIELDS = { "path", "file_path", "file", "directory", "dir", "cwd", "target" }

-- Fields that hold a shell command line.
local COMMAND_FIELDS = { "command", "cmd", "script" }

-- `.env` and every `.env.<suffix>` holds secrets wherever it sits. Templates
-- are refused too: one rule, no exceptions.
local function is_secret_file(path)
  local name = path:match("([^/]+)$") or path
  return name == ".env" or name:sub(1, 5) == ".env."
end

local function under_protected_dir(path)
  for _, root in ipairs(PROTECTED_DIRS) do
    if path == root or path:sub(1, #root + 1) == root .. "/" then
      return root
    end
  end
  return nil
end

-- Expand the spellings a command can use for a protected root, so that
-- `~/.ssh`, `$HOME/.ssh`, and `${HOME}/.ssh` all match.
local ALIASES = {
  { "~", home },
  { "$HOME", home },
  { "${HOME}", home },
  { "$XDG_CONFIG_HOME", xdg_config },
  { "${XDG_CONFIG_HOME}", xdg_config },
}

local function expand(text)
  local out = { text }
  for _, alias in ipairs(ALIASES) do
    local prefix, replacement = alias[1], alias[2]
    for _, root in ipairs(PROTECTED_DIRS) do
      local suffix = root:sub(#replacement + 1)
      if suffix ~= "" then
        local spelled = prefix .. suffix
        if text:find(spelled, 1, true) then
          out[#out + 1] =
            text:gsub(spelled:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0"), replacement .. suffix)
        end
      end
    end
  end
  return out
end

-- A command line is checked token by token, because the path can be an
-- argument to any binary: `cat ~/.ssh/id_rsa`, `git add .env`, and so on.
local function check_command(text)
  for _, variant in ipairs(expand(text)) do
    for token in variant:gmatch("%S+") do
      local clean = token:gsub("^['\"]", ""):gsub("['\"]$", "")
      local root = under_protected_dir(clean)
      if root then
        return root
      end
      if is_secret_file(clean) then
        return clean
      end
    end
    -- A path can also sit inside a longer string, such as
    -- `--file=/home/me/.ssh/config`.
    for _, root in ipairs(PROTECTED_DIRS) do
      if variant:find(root .. "/", 1, true) then
        return root
      end
    end
  end
  return nil
end

local function check_path(text)
  for _, variant in ipairs(expand(text)) do
    local root = under_protected_dir(variant)
    if root then
      return root
    end
    if is_secret_file(variant) then
      return variant
    end
  end
  return nil
end

-- Nested calls (`batch`, `code_execution`) carry their own tool inputs.
local function check_input(input, seen)
  if type(input) ~= "table" or seen[input] then
    return nil
  end
  seen[input] = true
  for _, field in ipairs(PATH_FIELDS) do
    local value = input[field]
    if type(value) == "string" then
      local hit = check_path(value)
      if hit then
        return hit
      end
    end
  end
  for _, field in ipairs(COMMAND_FIELDS) do
    local value = input[field]
    if type(value) == "string" then
      local hit = check_command(value)
      if hit then
        return hit
      end
    end
  end
  for _, inner in pairs(input) do
    if type(inner) == "table" then
      local hit = check_input(inner, seen)
      if hit then
        return hit
      end
    end
  end
  return nil
end

maki.api.set_slot("tool.*.input", function(prev, input, ctx)
  local hit = check_input(input, {})
  if hit then
    return nil,
      ("%s is off limits: %s holds secrets. Ask the user to handle it."):format(ctx.tool, hit)
  end
  return prev(input, ctx)
end)
