---@type LazyPlugin
return {
  [1] = "tpope/vim-vinegar",
  lazy = false,
  enabled = true,
  ft = {
    "netrw",
  },
  keys = {
    { [1] = "-", [2] = nil, desc = "vinegar-up" },
  },
}
