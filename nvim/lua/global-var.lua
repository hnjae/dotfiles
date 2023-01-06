_MAPPING_PREFIX = {
  ["tab"] = "<Leader>nt",
  ["edit"] = "<Leader>ne",
  ["window"] = "<Leader>nw",
  ["sidebar"] = "<Leader>s",
  ["open"] = "<F6>",
  ["fuzzy-finder"] = "<F3>",
}

-- _LANG_PREFIX = 's'
-- TODO: remove these code <2023-01-05, Hyunjae Kim>
-- vim.cmd([[map s <Nop>]])

-- vim.api.nvim_del_keymap("n", "s")

-- _OPEN_PREFIX = "<Leader>p"
_TAB_PREFIX = "<Leader>nt"
_EDIT_PREFIX = "<Leader>ne"
_WINDOW_PREFIX = "<Leader>nw"
-- _SIDEBAR_PREFIX = "<Leader>s"

-- _SEARCH_PREFIX = "<Leader>/"


-- TODO: remove these code
local packages = {}
for _, pack in ipairs(require("plugins.misc")) do
  packages[pack[1]:sub(pack[1]:find("/")+1, -1)] = true
end
_IS_PLUGIN = function (plugin)
  return packages[plugin] == true
end
