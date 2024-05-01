-- https://github.com/sontungexpt/url-open

---@type LazySpec
return {
  [1] = "sontungexpt/url-open",
  lazy = true,
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
    open_only_when_cursor_on_url = true,
  },
}
