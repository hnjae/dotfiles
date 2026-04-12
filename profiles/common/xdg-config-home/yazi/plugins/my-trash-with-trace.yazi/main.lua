local hovered_item = ya.sync(function()
  local hovered = cx.active.current.hovered
  if not hovered then
    return nil
  end

  return {
    url = Url(hovered.url),
    name = hovered.name,
    stem = hovered.url.stem or hovered.name,
    is_dir = hovered.cha.is_dir,
  }
end)

local function notify(level, content, timeout)
  ya.notify({
    title = "Trash with trace",
    content = content,
    timeout = timeout,
    level = level,
  })
end

local function mediainfo_for(target)
  local output, err = Command("mediainfo"):arg({ "--", target }):output()
  if not output then
    return nil, err
  end

  local content = output.stdout
  if output.stderr ~= "" then
    if content ~= "" and not content:match("\n$") then
      content = content .. "\n"
    end
    content = content .. output.stderr
  end

  if content == "" then
    return nil, "mediainfo returned no output"
  end

  return content, nil
end

return {
  entry = function()
    local hovered = hovered_item()
    if not hovered then
      notify("warn", "No hovered file.", 6)
      return
    end
    if hovered.is_dir then
      notify("warn", "Hovered item is a directory.", 6)
      return
    end

    local confirmed = ya.confirm({
      pos = { "center", w = 60, h = 10 },
      title = "Trash with trace",
      body = string.format(
        'Trash "%s" and create a trace file?\n\nThis only works for files.',
        hovered.name
      ),
    })
    if not confirmed then
      return
    end

    local parent = hovered.url.parent
    if not parent then
      notify("error", "Couldn't determine the parent directory.", 7)
      return
    end

    local target = tostring(hovered.url)
    local content, info_err = mediainfo_for(target)
    if not content then
      notify("error", "Failed to collect mediainfo: " .. tostring(info_err), 7)
      return
    end

    local trace_name = hovered.stem .. " DELETED"
    local final_url = parent:join(trace_name)
    local temp_url =
      parent:join(string.format("%s.tmp-%d", trace_name, math.floor(ya.time() * 1000)))

    local ok, write_err = fs.write(Url(temp_url), content)
    if not ok then
      notify("error", "Failed to write the trace file: " .. tostring(write_err), 7)
      return
    end

    local status, trash_err = Command("trash-put"):arg({ "--", target }):status()
    if not status or not status.success then
      fs.remove("file", Url(temp_url))
      notify("error", "Failed to trash the file: " .. tostring(trash_err), 7)
      return
    end

    local renamed, rename_err = fs.rename(Url(temp_url), Url(final_url))
    if not renamed then
      notify(
        "error",
        "File was trashed, but finalizing the trace file failed: " .. tostring(rename_err),
        8
      )
      return
    end

    ya.emit("reveal", { Url(final_url) })
    notify("info", "Trashed hovered file and created its trace file.", 4)
  end,
}
