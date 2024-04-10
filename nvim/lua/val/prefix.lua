local package_path = (...):match("(.-)[^%.]+$")
local map_keyword = require(package_path .. ".map-keyword")

-- this prefix will be registered by which.key
return {
  -- NOTE(buffer): filetype 에 따라 달라지거나, buffer 와 interact 하는 기능 할당.
  buffer = "s",
  toggleterm_send = "s" .. map_keyword.terminal,
  buffer_finder = "s" .. map_keyword.finder,
  sniprun = "sr",
  task = "s" .. map_keyword.task,
  repl = "sp",

  -- NOTE(close): 무언가를 닫거나, clear 하는 기능을 할당.
  close = "Z",

  -- NOTE(<Leader>): filetype 와 무관한 기능 할당
  finder = "<Leader>" .. map_keyword.finder,
  focus = "<Leader>" .. map_keyword.focus,
  sidebar = "<Leader>b",
  trouble = "<Leader>" .. map_keyword.trouble,
  window = "<Leader>" .. map_keyword.window,
  git = "<Leader>" .. map_keyword.git,
  new = "<Leader>n",
  snippet = "<Leader>" .. map_keyword.snippet,

  open = "<F6>",
}
