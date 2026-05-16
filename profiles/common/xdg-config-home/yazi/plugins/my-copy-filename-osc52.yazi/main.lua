local target_names = ya.sync(function()
  local names = {}
  local selected = cx.active.selected

  if #selected > 0 then
    for _, url in pairs(selected) do
      names[#names + 1] = url.name or tostring(url)
    end
    return names
  end

  local hovered = cx.active.current.hovered
  if hovered then
    names[1] = hovered.name
  end

  return names
end)

local function notify(level, content, timeout)
  ya.notify({
    title = "Copy filename OSC 52",
    content = content,
    timeout = timeout,
    level = level,
  })
end

local function count_label(count)
  return string.format("%d %s", count, count == 1 and "filename" or "filenames")
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

local function copy_with_osc52(data)
  local tty, open_err = io.open("/dev/tty", "w")
  if not tty then
    return nil, "Failed to open `/dev/tty`: " .. tostring(open_err)
  end

  local ok, write_err = tty:write("\027]52;c;" .. base64(data) .. "\007")
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

return {
  entry = function()
    local names = target_names()
    if #names == 0 then
      notify("warn", "No hovered or selected entries.", 6)
      return
    end

    local ok, err = copy_with_osc52(table.concat(names, "\n"))
    if not ok then
      notify("error", err, 7)
      return
    end

    notify("info", string.format("Copied %s with OSC 52.", count_label(#names)), 4)
  end,
}
