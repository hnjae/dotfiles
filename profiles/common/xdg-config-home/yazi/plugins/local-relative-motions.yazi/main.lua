local MOTION_AND_OP_KEYS = {
  { on = "0" },
  { on = "1" },
  { on = "2" },
  { on = "3" },
  { on = "4" },
  { on = "5" },
  { on = "6" },
  { on = "7" },
  { on = "8" },
  { on = "9" },
  { on = "d" },
  { on = "v" },
  { on = "y" },
  { on = "x" },
  { on = "<Space>" },
  { on = "t" },
  { on = "L" },
  { on = "H" },
  { on = "w" },
  { on = "W" },
  { on = "<" },
  { on = ">" },
  { on = "~" },
  { on = "g" },
  { on = "j" },
  { on = "k" },
  { on = "h" },
  { on = "l" },
  { on = "<Down>" },
  { on = "<Up>" },
  { on = "<Left>" },
  { on = "<Right>" },
}

local G_DIRECTIONS = {
  { on = "g" },
  { on = "j" },
  { on = "k" },
  { on = "<Down>" },
  { on = "<Up>" },
  { on = "t" },
}

local OP_DIRECTIONS = {
  { on = "j" },
  { on = "k" },
  { on = "<Down>" },
  { on = "<Up>" },
}

local function normalize_direction(dir)
  if dir == "<Down>" then
    return "j"
  elseif dir == "<Up>" then
    return "k"
  elseif dir == "<Left>" then
    return "h"
  elseif dir == "<Right>" then
    return "l"
  end

  return dir
end

local function read_key(cands)
  local idx = ya.which({ cands = cands, silent = true })
  if not idx then
    return nil
  end

  return normalize_direction(cands[idx].on)
end

local function operation_directions(cmd)
  return {
    OP_DIRECTIONS[1],
    OP_DIRECTIONS[2],
    OP_DIRECTIONS[3],
    OP_DIRECTIONS[4],
    { on = cmd },
  }
end

local function parse_command(initial)
  local count = initial or ""

  while true do
    local key = read_key(MOTION_AND_OP_KEYS)
    if not key then
      return nil, nil, nil
    end

    if not tonumber(key) then
      if key == "g" then
        return tonumber(count), key, read_key(G_DIRECTIONS)
      elseif key == "<Space>" then
        return tonumber(count), "v", "v"
      elseif key == "v" or key == "d" or key == "y" or key == "x" then
        return tonumber(count), key, read_key(operation_directions(key))
      end

      return tonumber(count), key, nil
    end

    count = count .. key
  end
end

local function is_tab_command(cmd)
  return cmd == "t" or cmd == "H" or cmd == "L" or cmd == "w" or cmd == "W" or cmd == "<" or cmd == ">" or cmd == "~"
end

local active_tab_index = ya.sync(function()
  return cx.tabs.idx
end)

local first_dir_index = ya.sync(function()
  local files = cx.active.current.files

  for i = 1, #files do
    if files[i].cha.is_dir then
      return i - 1
    end
  end

  return nil
end)

local function enter_dirs(count)
  for _ = 1, count do
    ya.emit("enter", {})

    local idx = first_dir_index()
    if idx then
      ya.emit("arrow", { "top" })
      ya.emit("arrow", { idx })
    end
  end
end

local function handle_tab_command(count, cmd)
  if cmd == "t" then
    for _ = 1, count do
      ya.emit("tab_create", {})
    end
  elseif cmd == "H" then
    ya.emit("tab_switch", { -count, relative = true })
  elseif cmd == "L" then
    ya.emit("tab_switch", { count, relative = true })
  elseif cmd == "w" then
    ya.emit("tab_close", { count - 1 })
  elseif cmd == "W" then
    local current = active_tab_index()
    local last = current + count - 1
    for _ = current, last do
      ya.emit("tab_close", { current - 1 })
    end
    ya.emit("tab_switch", { current - 1 })
  elseif cmd == "<" then
    ya.emit("tab_swap", { -count })
  elseif cmd == ">" then
    ya.emit("tab_swap", { count })
  elseif cmd == "~" then
    ya.emit("tab_swap", { count - active_tab_index() })
  end
end

local function handle_operation(count, cmd, direction)
  if direction ~= "j" and direction ~= "k" and direction ~= cmd then
    return
  end

  ya.emit("visual_mode", {})

  if direction == "k" then
    ya.emit("arrow", { -count })
  elseif direction == "j" then
    ya.emit("arrow", { count })
  else
    ya.emit("arrow", { count - 1 })
  end

  ya.emit("escape", { visual = true })

  if cmd == "d" then
    ya.emit("remove", {})
  elseif cmd == "y" then
    ya.emit("yank", {})
  elseif cmd == "x" then
    ya.emit("yank", { cut = true })
  end
end

local function initial_count(job)
  if not job or not job.args or not job.args[1] then
    return nil
  end

  local count = tonumber(job.args[1])
  if not count then
    return nil
  end

  return tostring(count)
end

return {
  entry = function(_, job)
    local count, cmd, direction = parse_command(initial_count(job))
    if not count or not cmd then
      return
    end

    if cmd == "g" then
      if direction == "g" then
        ya.emit("arrow", { "top" })
        ya.emit("arrow", { count - 1 })
      elseif direction == "j" then
        ya.emit("arrow", { count })
      elseif direction == "k" then
        ya.emit("arrow", { -count })
      elseif direction == "t" then
        ya.emit("tab_switch", { count - 1 })
      end
    elseif cmd == "j" then
      ya.emit("arrow", { count })
    elseif cmd == "k" then
      ya.emit("arrow", { -count })
    elseif cmd == "h" then
      for _ = 1, count do
        ya.emit("leave", {})
      end
    elseif cmd == "l" then
      enter_dirs(count)
    elseif is_tab_command(cmd) then
      handle_tab_command(count, cmd)
    else
      handle_operation(count, cmd, direction)
    end
  end,
}
