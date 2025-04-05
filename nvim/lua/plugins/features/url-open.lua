---@type LazySpec
return {
  -- extend builtin gx and open various url (such as lazy.nvim's plugin)
  [1] = "sontungexpt/url-open",
  lazy = true,
  enabled = true,
  cmd = {
    "URLOpenUnderCursor",
    "URLOpenHighlightAllClear",
    "URLOpenHighlightAll",
  },
  ---@type LazyKeysSpec[]
  keys = {
    { [1] = "gx", [2] = "<cmd>URLOpenUnderCursor<CR>", desc = "url-open" },
  },
  opts = {
    open_only_when_cursor_on_url = false,
  },
}
