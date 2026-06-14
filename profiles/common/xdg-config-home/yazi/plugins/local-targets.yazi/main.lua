local snapshot = ya.sync(function(state)
  state.targets = state.targets or {}
  local hovered = cx.active.current.hovered

  return {
    cwd = tostring(cx.active.current.cwd),
    hovered = hovered and {
      path = tostring(hovered.url),
      name = hovered.name,
      is_dir = hovered.cha and hovered.cha.is_dir,
    } or nil,
    selected_count = #cx.active.selected,
  }
end)

local add_target_state = ya.sync(function(state, path, label)
  state.targets = state.targets or {}

  for i, target in ipairs(state.targets) do
    if target.path == path then
      return {
        added = false,
        label = target.label,
        index = i,
      }
    end
  end

  state.targets[#state.targets + 1] = {
    path = path,
    label = label,
  }

  return {
    added = true,
    label = label,
    index = #state.targets,
  }
end)

local clear_targets_state = ya.sync(function(state)
  state.targets = {}
end)

local get_targets = ya.sync(function(state)
  state.targets = state.targets or {}

  local copied = {}
  for i, target in ipairs(state.targets) do
    copied[i] = {
      path = target.path,
      label = target.label,
    }
  end

  return copied
end)

local function notify(level, content, timeout)
  ya.notify({
    title = "Targets",
    content = content,
    timeout = timeout,
    level = level,
  })
end

local function path_label(url)
  local path = tostring(url)
  local home = os.getenv("HOME")
  if home and path == home then
    return "~"
  end
  if home and path:sub(1, #home + 1) == home .. "/" then
    return "~" .. path:sub(#home + 1)
  end
  return path
end

local function add_target(path)
  local result = add_target_state(path, path_label(path))
  if not result.added then
    notify("info", "Already targeted: " .. result.label, 4)
    return
  end

  notify("info", "Target added: " .. result.label, 4)
end

local function list_targets()
  local targets = get_targets()
  if #targets == 0 then
    notify("warn", "No targets set.", 5)
    return
  end

  local lines = {}
  for i, target in ipairs(targets) do
    lines[#lines + 1] = string.format("%d. %s", i, target.label)
  end

  notify("info", table.concat(lines, "\n"), 8)
end

local function target_cands(targets, verb)
  local keys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
  local cands = {}

  for i = 1, math.min(#targets, #keys) do
    cands[i] = {
      on = keys[i],
      desc = verb .. " to " .. targets[i].label,
    }
  end

  return cands
end

local function choose_target(verb)
  local targets = get_targets()
  if #targets == 0 then
    notify("warn", "No targets set.", 5)
    return nil
  end

  if #targets == 1 then
    local target = targets[1]
    local ok = ya.confirm({
      pos = { "center", w = 62, h = 8 },
      title = verb .. " to target?",
      body = verb .. " marked files to " .. target.label .. "?",
    })
    return ok and target or nil
  end

  if #targets <= 10 then
    local idx = ya.which({ cands = target_cands(targets, verb) })
    return idx and targets[idx] or nil
  end

  local lines = {}
  for i, target in ipairs(targets) do
    lines[#lines + 1] = string.format("%d. %s", i, target.label)
  end
  notify("info", verb .. " target:\n" .. table.concat(lines, "\n"), 8)

  local value, event = ya.input({
    title = string.format("%s target (1-%d):", verb, #targets),
    value = "",
    pos = { "top-center", y = 2, w = 50 },
  })
  if event ~= 1 or not value or value == "" then
    return nil
  end

  local idx = tonumber(value)
  if not idx or idx < 1 or idx > #targets then
    notify("warn", "Invalid target: " .. value, 5)
    return nil
  end

  return targets[idx]
end

local function target_is_directory(target)
  local url = Url(target.path)
  local cha, err = fs.cha(url, false)
  if not cha then
    notify("error", "Couldn't inspect target: " .. tostring(err), 7)
    return false
  end

  if not cha.is_dir then
    notify("warn", "Target is not a directory: " .. target.label, 5)
    return false
  end

  return true
end

local function transfer_to_target(cut)
  local data = snapshot()
  if data.selected_count == 0 then
    notify("warn", "No marked files.", 5)
    return
  end

  local target = choose_target(cut and "Move" or "Copy")
  if not target then
    return
  end

  if not target_is_directory(target) then
    return
  end

  if cut then
    ya.emit("yank", { cut = true })
  else
    ya.emit("yank", {})
  end

  if target.path == data.cwd then
    ya.emit("paste", {})
    return
  end

  ya.emit("cd", { Url(target.path) })
  ya.emit("paste", {})
  ya.emit("cd", { Url(data.cwd) })
end

local actions = {}

function actions.add_cwd()
  add_target(snapshot().cwd)
end

function actions.add_hovered()
  local hovered = snapshot().hovered
  if not hovered then
    notify("warn", "No hovered entry.", 5)
    return
  end

  if not hovered.is_dir then
    notify("warn", "Hovered entry is not a directory: " .. hovered.name, 5)
    return
  end

  add_target(hovered.path)
end

function actions.clear()
  clear_targets_state()
  notify("info", "Targets cleared.", 4)
end

function actions.list()
  list_targets()
end

function actions.copy()
  transfer_to_target(false)
end

function actions.move()
  transfer_to_target(true)
end

return {
  entry = function(_, job)
    local action = tostring(job.args[1] or ""):gsub("-", "_")

    if actions[action] then
      actions[action]()
      return
    end

    notify("warn", "Unknown action: " .. action, 5)
  end,
}
