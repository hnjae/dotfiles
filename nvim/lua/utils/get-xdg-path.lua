local xdg_cache = {}
return function(type)
  if xdg_cache[type] ~= nil then
    return xdg_cache[type]
  end

  if type == "state" then
    xdg_cache[type] = os.getenv("XDG_STATE_HOME")
      or os.getenv("HOME") .. "/.local/state"
    return xdg_cache[type]
  end

  return ""
end
