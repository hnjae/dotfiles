local current_hovered = ya.sync(function()
  local hovered = cx.active.current.hovered
  return hovered and Url(hovered.url) or nil
end)

local function fail(content)
  ya.notify({
    title = "Open associated",
    content = content,
    timeout = 7,
    level = "error",
  })
end

local function command_for(url)
  local target = tostring(url)
  local os = ya.target_os()

  if os == "macos" then
    return Command("open"):arg(target)
  end

  if os == "windows" then
    return Command("cmd"):arg({ "/C", "start", "", target })
  end

  return Command("xdg-open"):arg(target)
end

return {
  entry = function()
    local hovered = current_hovered()
    if not hovered then
      fail("No hovered entry to open.")
      return
    end

    local child, err = command_for(hovered):spawn()
    if not child then
      fail("Failed to open entry: " .. tostring(err))
    end
  end,
}
