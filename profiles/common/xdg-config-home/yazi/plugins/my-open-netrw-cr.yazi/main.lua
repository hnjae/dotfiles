--- @sync entry

return {
  entry = function()
    local hovered = cx.active.current.hovered
    if not hovered then
      return
    end

    if hovered.cha.is_dir then
      ya.emit("enter", {})
      return
    end

    if hovered.url.is_archive then
      ya.emit("plugin", { "my-open-associated" })
      return
    end

    ya.emit("open", { hovered = true })
  end,
}
