local target_names = ya.sync(function()
  local names = {}

  for _, url in pairs(cx.active.selected) do
    names[#names + 1] = url.name or tostring(url)
  end

  if #names > 0 then
    return names
  end

  local hovered = cx.active.current.hovered
  if hovered then
    return { hovered.name }
  end

  return names
end)

local function warn(content)
  ya.notify({
    title = "Copy bracket content",
    content = content,
    timeout = 6,
    level = "warn",
  })
end

local function info(content)
  ya.notify({
    title = "Copy bracket content",
    content = content,
    timeout = 4,
    level = "info",
  })
end

local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function base64_char(index)
  return alphabet:sub(index + 1, index + 1)
end

local function base64(data)
  local encoded = {}

  for index = 1, #data, 3 do
    local first = data:byte(index)
    local second = data:byte(index + 1)
    local third = data:byte(index + 2)
    local value = first * 0x10000 + (second or 0) * 0x100 + (third or 0)

    encoded[#encoded + 1] = base64_char(math.floor(value / 0x40000) % 64)
    encoded[#encoded + 1] = base64_char(math.floor(value / 0x1000) % 64)

    if second then
      encoded[#encoded + 1] = base64_char(math.floor(value / 0x40) % 64)
    else
      encoded[#encoded + 1] = "="
    end

    if third then
      encoded[#encoded + 1] = base64_char(value % 64)
    else
      encoded[#encoded + 1] = "="
    end
  end

  return table.concat(encoded)
end

local function osc52_sequence(encoded)
  local sequence = "\027]52;c;" .. encoded .. "\007"

  if os.getenv("TMUX") then
    return "\027Ptmux;\027" .. sequence .. "\027\\"
  end

  return sequence
end

local function copy_with_osc52(data)
  local tty, open_err = io.open("/dev/tty", "w")
  if not tty then
    return nil, "Failed to open `/dev/tty`: " .. tostring(open_err)
  end

  local ok, write_err = tty:write(osc52_sequence(base64(data)))
  if not ok then
    tty:close()
    return nil, "Failed to write OSC 52 data: " .. tostring(write_err)
  end

  local flushed, flush_err = tty:flush()
  tty:close()

  if not flushed then
    return nil, "Failed to flush OSC 52 data: " .. tostring(flush_err)
  end

  return true, nil
end

local function extract(name, kind)
  local matched

  if kind == "round-first" then
    matched = name:match("%b()")
  elseif kind == "round-last" then
    for value in name:gmatch("%b()") do
      matched = value
    end
  elseif kind == "square-first" then
    matched = name:match("%b[]")
  elseif kind == "square-last" then
    for value in name:gmatch("%b[]") do
      matched = value
    end
  end

  return matched and matched:sub(2, -2) or nil
end

return {
  entry = function(_, job)
    local kind = job.args[1]
    if kind ~= "round-first" and kind ~= "round-last" and kind ~= "square-first" and kind ~= "square-last" then
      warn("Unsupported bracket type.")
      return
    end

    local names = target_names()
    if #names == 0 then
      warn("No hovered or selected file.")
      return
    end

    local results = {}
    for _, name in ipairs(names) do
      local value = extract(name, kind)
      if value then
        results[#results + 1] = value
      end
    end

    if #results == 0 then
      local label = (kind == "square-first" or kind == "square-last") and "[]" or "()"
      warn("No " .. label .. " content found in the target name(s).")
      return
    end

    local ok, err = copy_with_osc52(table.concat(results, "\n"))
    if not ok then
      warn(err)
      return
    end

    info(string.format("Copied %d value(s) with OSC 52.", #results))
  end,
}
