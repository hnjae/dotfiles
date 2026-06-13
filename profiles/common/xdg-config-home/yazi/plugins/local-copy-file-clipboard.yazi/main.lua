local targets = ya.sync(function()
  local items = {}
  local selected = cx.active.selected

  if #selected > 0 then
    for _, url in pairs(selected) do
      items[#items + 1] = {
        url = Url(url),
        name = url.name or tostring(url),
      }
    end
  else
    local hovered = cx.active.current.hovered
    if hovered then
      items[1] = {
        url = Url(hovered.url),
        name = hovered.name,
      }
    end
  end

  return items
end)

local function notify(level, content, timeout)
  ya.notify({
    title = "Copy file clipboard",
    content = content,
    timeout = timeout,
    level = level,
  })
end

local function count_label(count, singular, plural)
  return string.format("%d %s", count, count == 1 and singular or plural)
end

local function file_uri(url)
  local path = tostring(url)
  local encoded = path:gsub("[^%w%-%._~/]", function(char)
    return string.format("%%%02X", string.byte(char))
  end)

  return "file://" .. encoded
end

local function uri_list(items)
  local lines = {}
  for _, item in ipairs(items) do
    lines[#lines + 1] = file_uri(item.url)
  end
  return table.concat(lines, "\r\n") .. "\r\n"
end

local function copy_with_wl_copy(data)
  local child, err =
    Command("wl-copy"):arg({ "--type", "text/uri-list" }):stdin(Command.PIPED):spawn()

  if not child then
    return nil, "Failed to start `wl-copy`: " .. tostring(err)
  end

  local written, write_err = child:write_all(data)
  if not written then
    return nil, "Failed to write clipboard data: " .. tostring(write_err)
  end

  local flushed, flush_err = child:flush()
  if not flushed then
    return nil, "Failed to flush clipboard data: " .. tostring(flush_err)
  end

  local status, wait_err = child:wait()
  if not status then
    return nil, "Failed to finish `wl-copy`: " .. tostring(wait_err)
  end
  if not status.success then
    return nil, string.format("`wl-copy` exited with code %s", tostring(status.code))
  end

  return true, nil
end

return {
  entry = function()
    local items = targets()
    if #items == 0 then
      notify("warn", "No hovered or selected entries.", 6)
      return
    end

    local ok, err = copy_with_wl_copy(uri_list(items))
    if not ok then
      notify("error", err, 7)
      return
    end

    notify(
      "info",
      string.format(
        "Copied %s to the desktop clipboard for file-manager paste.",
        count_label(#items, "entry", "entries")
      ),
      4
    )
  end,
}
