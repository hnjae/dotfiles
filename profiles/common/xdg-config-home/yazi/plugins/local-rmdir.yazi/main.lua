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
    title = "rmdir",
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
    return string.format(
      'Remove "%s" with rmdir?\n\nOnly empty directories can be removed.',
      items[1].name
    )
  end

  return string.format(
    "Run rmdir on %s?\n\nOnly empty directories can be removed.",
    count_label(#items, "selected entry", "selected entries")
  )
end

return {
  entry = function()
    local items = targets()
    if #items == 0 then
      notify("warn", "No hovered or selected entries.", 6)
      return
    end

    local ok = ya.confirm({
      pos = { "center", w = 60, h = 10 },
      title = "Remove empty directories",
      body = confirm_body(items),
    })
    if not ok then
      return
    end

    local removed = 0
    local failed = 0
    local first_error = nil

    for _, item in ipairs(items) do
      local item_ok, err = fs.remove("dir", item.url)
      if item_ok then
        removed = removed + 1
      else
        failed = failed + 1
        if first_error == nil then
          first_error = err
        end
      end
    end

    if failed == 0 then
      notify(
        "info",
        string.format("Removed %s.", count_label(removed, "empty directory", "empty directories")),
        4
      )
      return
    end

    if removed == 0 and #items == 1 then
      notify(
        "warn",
        string.format('Failed to remove "%s": %s', items[1].name, tostring(first_error)),
        7
      )
      return
    end

    local content = {}
    if removed > 0 then
      content[#content + 1] =
        string.format("Removed %s.", count_label(removed, "empty directory", "empty directories"))
    end
    content[#content + 1] =
      string.format("Failed to remove %s.", count_label(failed, "entry", "entries"))
    content[#content + 1] = "Only empty directories can be removed."

    notify("warn", table.concat(content, " "), 7)
  end,
}
