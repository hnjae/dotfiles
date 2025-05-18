local selected_or_hovered = ya.sync(function()
  local tab, paths = cx.active, {}
  for _, u in pairs(tab.selected) do
    paths[#paths + 1] = tostring(u)
  end
  if #paths == 0 and tab.current.hovered then
    paths[1] = tostring(tab.current.hovered.url)
  end
  return paths
end)

return {
  entry = function()
    ya.manager_emit("escape", { visual = true })

    local urls = selected_or_hovered()

    if #urls == 0 then
      return ya.notify({
        title = "rmdir",
        content = "No file selected",
        level = "warn",
        timeout = 5,
      })
    end

    -- ya.notify({ title = #urls, content = table.concat(urls, " "), level = "info", timeout = 5 })

    local status, err = Command("rmdir")
      :arg("--ignore-fail-on-non-empty")
      :args(urls)
      :spawn()
      :wait()

    if status and status.success then
      ya.notify({
        title = "rmdir",
        content = "Successfully rmdir of dir(s)",
        level = "info",
        timeout = 5,
      })
    end

    if not status or not status.success then
      ya.notify({
        title = "rmdir",
        content = string.format(
          "Could not rmdir selected dir(s) %s",
          status and status.code or err
        ),
        level = "error",
        timeout = 5,
      })
    end
  end,
}
