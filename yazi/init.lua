-- ~/.config/yazi/init.lua
function Linemode:size_and_mtime()
  local time = math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ""
  elseif os.date("%Y-%m-%d", time) == os.date("%Y-%m-%d") then
    time = os.date("T %H:%M:%S", time)
  else
    time = os.date("%Y-%m-%d", time)
  end

  local size = self._file:size()
  return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

function Linemode:mtime()
  local time = math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ""
  else
    time = os.date("%Y-%m-%d %H:%M:%S", time)
  end
  return time
end

function Linemode:btime()
  local time = math.floor(self._file.cha.btime or 0)
  if time == 0 then
    time = ""
  else
    time = os.date("%Y-%m-%d %H:%M:%S", time)
  end
  return time
end

require("git"):setup() -- yazi-rs/plugins:git
