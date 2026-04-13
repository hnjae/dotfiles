local targets = ya.sync(function()
  local items = {}

  if #cx.active.selected > 0 then
    for _, url in pairs(cx.active.selected) do
      items[#items + 1] = tostring(url)
    end
  else
    local hovered = cx.active.current.hovered
    if hovered then
      items[1] = tostring(hovered.url)
    end
  end

  return {
    cwd = tostring(cx.active.current.cwd),
    items = items,
  }
end)

local function relative_to(cwd, path)
  if path == cwd then
    return "."
  end

  if cwd == "/" then
    return path:sub(2)
  end

  if path:sub(1, #cwd) ~= cwd then
    return path
  end

  local next_char = path:sub(#cwd + 1, #cwd + 1)
  if next_char ~= "" and next_char ~= "/" then
    return path
  end

  local relative = path:sub(#cwd + 2)
  return relative ~= "" and relative or "."
end

local function notify(level, content, timeout)
  ya.notify({
    title = "Rename with vimv",
    content = content,
    timeout = timeout,
    level = level,
  })
end

return {
  entry = function()
    local data = targets()
    if #data.items == 0 then
      notify("warn", "No hovered or selected item.", 6)
      return
    end

    local items = {}
    for i, item in ipairs(data.items) do
      items[i] = relative_to(data.cwd, item)
    end

    local permit = ui.hide()
    local cmd = Command("vimv"):cwd(data.cwd):stdin(Command.INHERIT):stdout(Command.INHERIT):stderr(Command.INHERIT)

    for _, item in ipairs(items) do
      cmd:arg(item)
    end

    local status, err = cmd:status()
    permit:drop()

    if not status then
      notify("error", "Failed to start vimv: " .. tostring(err), 8)
      return
    end
    if not status.success then
      notify("warn", "vimv exited with code " .. tostring(status.code) .. ".", 6)
    end
  end,
}
