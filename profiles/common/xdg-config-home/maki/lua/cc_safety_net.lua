-- Run cc-safety-net's command checks before a tool call.
--
-- cc-safety-net owns the shell parser, the destructive-command rules, and
-- the user's rulebooks in ~/.cc-safety-net. Its public API checks commands
-- only, so secret paths stay in secrets_guard.lua. Only inputs that carry a
-- command field pay the Node startup cost.
--
-- Nothing happens when node, cc-safety-net, or the wrapper is missing: the
-- layer is not installed and secrets_guard still protects paths.
--
-- `code_execution` runs Python, not a shell command, so it is not checked
-- here; its sandbox is a separate boundary.

local home = maki.uv.os_homedir()
local config = maki.env.config_dir()

local API_CANDIDATES = {
  maki.fs.joinpath(home, ".local/share/maki/npm/node_modules/cc-safety-net/dist/api.js"),
  maki.fs.joinpath(home, ".pi/agent/npm/node_modules/cc-safety-net/dist/api.js"),
}
local WRAPPER = maki.fs.joinpath(config, "lua/cc_safety_net/check.mjs")
local MAX_PAYLOAD = 64 * 1024
local TIMEOUT_MS = 3000
-- Runtime failures fail open by default: a broken Node install should not
-- stop every command. Set this to true to block instead.
local FAIL_CLOSED = false

local function first_existing(paths)
  for _, path in ipairs(paths) do
    if maki.fs.metadata(path) then
      return path
    end
  end
  return nil
end

local api = first_existing(API_CANDIDATES)
local node = maki.fn.executable("node")
if not api or not node or not maki.fs.metadata(WRAPPER) then
  maki.log.warn(
    "cc_safety_net: node, cc-safety-net, or check.mjs is missing; command guard disabled"
  )
  return {}
end

-- Fields that hold a shell command line, matching secrets_guard.lua.
local COMMAND_FIELDS = { "command", "cmd", "script" }

-- Nested calls (`batch`) carry their own tool inputs.
local function collect(input, seen, out)
  if type(input) ~= "table" or seen[input] then
    return
  end
  seen[input] = true
  for _, field in ipairs(COMMAND_FIELDS) do
    local value = input[field]
    if type(value) == "string" and value ~= "" then
      out[#out + 1] = value
    end
  end
  for _, inner in pairs(input) do
    if type(inner) == "table" then
      collect(inner, seen, out)
    end
  end
end

local function current_cwd(ctx)
  local session_id = nil
  if ctx and ctx.session_id then
    local ok, id = pcall(ctx.session_id, ctx)
    if ok then
      session_id = id
    end
  end
  if not session_id then
    session_id = maki.session.current()
  end
  if session_id then
    local info = maki.session.read({ session = session_id })
    if info and type(info.cwd) == "string" and info.cwd:sub(1, 1) == "/" then
      return info.cwd
    end
  end
  local cwd = maki.uv.cwd()
  if type(cwd) == "string" and cwd:sub(1, 1) == "/" then
    return cwd
  end
  return nil
end

local warned = false
local function warn_once(message)
  if not warned then
    warned = true
    maki.log.warn("cc_safety_net: " .. message)
  end
end

maki.api.set_slot("tool.*.input", function(prev, input, ctx)
  local function fail(message)
    warn_once(message)
    if FAIL_CLOSED then
      return nil, "cc-safety-net is unavailable: " .. message
    end
    return prev(input, ctx)
  end

  local commands = {}
  collect(input, {}, commands)
  if #commands == 0 then
    return prev(input, ctx)
  end

  local cwd = current_cwd(ctx)
  if not cwd then
    return fail("no absolute cwd; skipping command check")
  end

  local items = {}
  for _, command in ipairs(commands) do
    items[#items + 1] = { command = command, cwd = cwd }
  end
  local payload, encode_err = maki.json.encode({ commands = items })
  if not payload then
    return fail("failed to encode commands: " .. tostring(encode_err))
  end
  if #payload > MAX_PAYLOAD then
    return fail("input exceeds " .. MAX_PAYLOAD .. " bytes; skipping command check")
  end

  local id, err = maki.fn.jobstart({ node, WRAPPER, api, payload }, {
    stderr = false,
  })
  if not id then
    return fail("failed to start node: " .. tostring(err))
  end

  local result = maki.fn.jobwait(id, TIMEOUT_MS)
  if not result then
    maki.fn.jobstop(id)
    return fail("check timed out")
  end

  local decision, decode_err = maki.json.decode(result.stdout or "")
  if not decision then
    return fail("bad decision: " .. tostring(decode_err))
  end
  if decision.kind == "deny" then
    return nil, ("%s is off limits: %s"):format(ctx.tool, decision.reason)
  end
  if decision.kind == "error" then
    return fail("analysis failed: " .. tostring(decision.reason))
  end
  return prev(input, ctx)
end)
