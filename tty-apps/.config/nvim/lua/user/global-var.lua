-- _LANG_PREFIX = 's'
-- vim.cmd([[map s <Nop>]])

-- vim.api.nvim_del_keymap("n", "s")

-- _OPEN_PREFIX = "<Leader>p"
_TAB_PREFIX = "<Leader>nt"
_EDIT_PREFIX = "<Leader>ne"
_WINDOW_PREFIX = "<Leader>nw"
-- _SIDEBAR_PREFIX = "<Leader>s"

-- _SEARCH_PREFIX = "<Leader>/"

_IS_PLUGIN = function (plugin)
  return packer_plugins ~= nil and packer_plugins[plugin]
end
