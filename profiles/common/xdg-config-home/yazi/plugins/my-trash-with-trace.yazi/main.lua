local targets = ya.sync(function()
  local items = {}
  local selected = cx.active.selected

  if #selected > 0 then
    for _, url in pairs(selected) do
      items[#items + 1] = {
        url = Url(url),
        name = url.name or tostring(url),
        stem = url.stem or url.name or tostring(url),
      }
    end
  else
    local hovered = cx.active.current.hovered
    if hovered then
      items[1] = {
        url = Url(hovered.url),
        name = hovered.name,
        stem = hovered.url.stem or hovered.name,
      }
    end
  end

  return items
end)

local function notify(level, content, timeout)
  ya.notify({
    title = "Trash with trace",
    content = content,
    timeout = timeout,
    level = level,
  })
end

local function count_label(count, singular, plural)
  return string.format("%d %s", count, count == 1 and singular or plural)
end

local function confirm_body(items)
  if #items == 1 then
    return string.format('Trash "%s" and create a trace file?\n\nThis only works for files.', items[1].name)
  end

  return string.format(
    "Trash %s and create trace files?\n\nThis only works for files.",
    count_label(#items, "selected entry", "selected entries")
  )
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

local function trash_with_trace(item)
  local cha, cha_err = fs.cha(item.url, false)
  if not cha then
    return nil, "Couldn't inspect the file: " .. tostring(cha_err)
  end
  if cha.is_dir then
    return nil, "Target is a directory."
  end

  local parent = item.url.parent
  if not parent then
    return nil, "Couldn't determine the parent directory."
  end

  local target = tostring(item.url)
  local content, info_err = mediainfo_for(target)
  if not content then
    return nil, "Failed to collect mediainfo: " .. tostring(info_err)
  end

  local trace_name = item.stem .. " DELETED"
  local final_url = parent:join(trace_name)
  local temp_url = parent:join(string.format("%s.tmp-%d", trace_name, math.floor(ya.time() * 1000)))

  local written, write_err = fs.write(temp_url, content)
  if not written then
    return nil, "Failed to write the trace file: " .. tostring(write_err)
  end

  local status, trash_err = Command("trash-put"):arg({ "--", target }):status()
  if not status or not status.success then
    fs.remove("file", temp_url)

    local reason = trash_err
    if reason == nil then
      reason = string.format("trash-put exited with code %s", tostring(status and status.code))
    end
    return nil, "Failed to trash the file: " .. tostring(reason)
  end

  local renamed, rename_err = fs.rename(temp_url, final_url)
  if not renamed then
    return nil, "File was trashed, but finalizing the trace file failed: " .. tostring(rename_err)
  end

  return final_url, nil
end

return {
  entry = function()
    local items = targets()
    if #items == 0 then
      notify("warn", "No hovered or selected entries.", 6)
      return
    end

    local confirmed = ya.confirm({
      pos = { "center", w = 60, h = 10 },
      title = "Trash with trace",
      body = confirm_body(items),
    })
    if not confirmed then
      return
    end

    local trashed = 0
    local failed = 0
    local first_error = nil
    local first_failed_name = nil
    local revealed = nil

    for _, item in ipairs(items) do
      local final_url, err = trash_with_trace(item)
      if final_url then
        trashed = trashed + 1
        revealed = final_url
      else
        failed = failed + 1
        if first_error == nil then
          first_error = err
          first_failed_name = item.name
        end
      end
    end

    if failed == 0 then
      if #items == 1 and revealed then
        ya.emit("reveal", { revealed })
        notify("info", "Trashed hovered file and created its trace file.", 4)
      else
        notify(
          "info",
          string.format("Trashed %s and created matching trace files.", count_label(trashed, "file", "files")),
          4
        )
      end
      return
    end

    if trashed == 0 and #items == 1 then
      notify("warn", string.format('Failed to process "%s": %s', first_failed_name, tostring(first_error)), 7)
      return
    end

    local content = {}
    if trashed > 0 then
      content[#content + 1] =
        string.format("Trashed %s and created matching trace files.", count_label(trashed, "file", "files"))
    end
    content[#content + 1] = string.format("Failed on %s.", count_label(failed, "entry", "entries"))
    content[#content + 1] = "This only works for files."

    notify("warn", table.concat(content, " "), 7)
  end,
}
