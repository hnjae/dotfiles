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

    ya.clipboard(table.concat(results, "\n"))
    info(string.format("Copied %d value(s) to the clipboard.", #results))
  end,
}
