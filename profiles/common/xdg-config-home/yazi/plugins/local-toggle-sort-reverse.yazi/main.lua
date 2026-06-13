--- @sync entry

return {
  entry = function()
    ya.emit("sort", { reverse = cx.active.pref.sort_reverse and "no" or "yes" })
  end,
}
