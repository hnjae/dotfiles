local package_path = (...):match("(.-)[^%.]+$")
local map_keyword = require(package_path .. ".map-keyword")

-- this prefix will be registered by which.key
return {
  -- NOTE(buffer): filetype 에 따라 달라지거나, buffer 와 interact 하는 기능 할당.
  buffer = "<LocalLeader>",
  toggleterm_send = "<LocalLeader>" .. map_keyword.terminal,
  ["find-local"] = "<LocalLeader>" .. map_keyword.find, -- which-key 맵핑 용도
  sniprun = "<LocalLeader>" .. "r",
  task = "<LocalLeader>" .. map_keyword.task,
  repl = "<LocalLeader>" .. "p",
  peek = "<LocalLeader>" .. "k",
  execute = "<LocalLeader>" .. map_keyword.execute,

  -- NOTE(close): 무언가를 닫거나, clear 하는 기능을 할당.
  -- close = "Z",
  close = "<F9>",

  -- NOTE(<Leader>): filetype 와 무관한 기능 할당
  find = "<Leader>" .. map_keyword.find,
  focus = "<Leader>" .. map_keyword.focus,
  sidebar = "<Leader>" .. "b",
  trouble = "<Leader>" .. map_keyword.trouble,
  window = "<Leader>" .. map_keyword.window,
  git = "<Leader>" .. map_keyword.git,
  new = "<Leader>" .. "n",
  -- snippet = "<Leader>" .. map_keyword.snippet,

  open = "<F6>",
}
