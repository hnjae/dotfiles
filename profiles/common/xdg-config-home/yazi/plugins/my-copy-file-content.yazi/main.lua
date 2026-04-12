local MAX_SIZE = 4 * 1024 * 1024

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
    title = "Copy file content",
    content = content,
    timeout = timeout,
    level = level,
  })
end

local function trim(s)
  return (s:gsub("%s+$", ""))
end

local function file_info(url)
  local output, err =
    Command("file"):arg({ "--brief", "--mime", "--dereference", "--", tostring(url) }):output()

  if not output then
    return nil, nil, "Failed to inspect the file: " .. tostring(err)
  end
  if not output.status.success then
    local reason = trim(output.stderr)
    if reason == "" then
      reason = string.format("`file` exited with code %s", tostring(output.status.code))
    end
    return nil, nil, "Failed to inspect the file: " .. reason
  end

  local line = trim(output.stdout)
  local mime, charset = line:match("^([^;]+);%s*charset=(.+)$")
  if not mime then
    mime = line
  end
  if not mime or mime == "" then
    return nil, nil, "Failed to detect the file MIME type."
  end

  return mime, charset, nil
end

local function content_kind(url, cha)
  if cha.len == 0 then
    return "text/plain", "text", nil
  end

  local mime, charset, err = file_info(url)
  if err then
    return nil, nil, err
  end

  if mime:match("^image/") then
    return mime, "image", nil
  end

  if charset and charset ~= "binary" then
    return "text/plain", "text", nil
  end

  return nil, nil, string.format("Unsupported file type: %s", mime)
end

local function copy_via_wl_copy(url, mime)
  local cat, cat_err = Command("cat"):arg({ "--", tostring(url) }):stdout(Command.PIPED):spawn()
  if not cat then
    return nil, "Failed to start `cat`: " .. tostring(cat_err)
  end

  local wl, wl_err = Command("wl-copy"):arg({ "--type", mime }):stdin(cat:take_stdout()):status()
  if not wl then
    cat:start_kill()
    cat:wait()
    return nil, "Failed to start `wl-copy`: " .. tostring(wl_err)
  end

  local cat_status, wait_err = cat:wait()
  if not cat_status then
    return nil, "Failed while reading the file: " .. tostring(wait_err)
  end
  if not cat_status.success then
    return nil, string.format("`cat` exited with code %s", tostring(cat_status.code))
  end
  if not wl.success then
    return nil, string.format("`wl-copy` exited with code %s", tostring(wl.code))
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
    if #items > 1 then
      notify("warn", "`yc` only supports one selected file at a time.", 7)
      return
    end

    local item = items[1]
    local cha, cha_err = fs.cha(item.url, true)
    if not cha then
      notify("error", "Couldn't inspect the file: " .. tostring(cha_err), 7)
      return
    end

    if cha.is_dir then
      notify("warn", "Directories are not supported.", 6)
      return
    end
    if cha.is_block or cha.is_char or cha.is_fifo or cha.is_sock then
      notify("warn", "Only regular files are supported.", 6)
      return
    end
    if cha.len > MAX_SIZE then
      notify("warn", "Files larger than 4 MiB are not supported.", 7)
      return
    end

    local mime, kind, kind_err = content_kind(item.url, cha)
    if not mime then
      notify("warn", kind_err, 7)
      return
    end

    local ok, copy_err = copy_via_wl_copy(item.url, mime)
    if not ok then
      notify("error", copy_err, 7)
      return
    end

    notify(
      "info",
      string.format("Copied %s as %s.", item.name, kind == "image" and mime or "text/plain"),
      4
    )
  end,
}
