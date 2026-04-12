local hovered_item = ya.sync(function()
  local hovered = cx.active.current.hovered
  if not hovered then
    return nil
  end

  return {
    url = Url(hovered.url),
    name = hovered.name,
  }
end)

local function notify(level, content, timeout)
  ya.notify({
    title = "Change permissions",
    content = content,
    timeout = timeout,
    level = level,
  })
end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

return {
  entry = function()
    local hovered = hovered_item()
    if not hovered then
      notify("warn", "No hovered entry.", 6)
      return
    end

    if ya.target_family() == "windows" then
      notify("warn", "Changing permissions is only supported on Unix-like systems.", 7)
      return
    end

    local mode, event = ya.input({
      title = "Permissions (eg 755 or u+x):",
      value = "",
      pos = { "top-center", y = 2, w = 50 },
    })

    if event ~= 1 or not mode then
      return
    end

    mode = trim(mode)
    if mode == "" then
      return
    end

    local output, err = Command("chmod"):arg({ "--", mode, tostring(hovered.url) }):output()

    if not output then
      notify("error", "Failed to start chmod: " .. tostring(err), 8)
      return
    end

    if not output.status.success then
      local detail = trim(output.stderr)
      if detail == "" then
        detail = "chmod exited with code " .. tostring(output.status.code) .. "."
      end
      notify("error", detail, 8)
      return
    end

    ya.emit("reveal", { hovered.url })
    notify("info", "Updated permissions for " .. hovered.name .. ".", 4)
  end,
}
