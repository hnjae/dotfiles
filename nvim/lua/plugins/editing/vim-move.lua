-- move text

---@type LazySpec
return {
  [1] = "matze/vim-move",
  lazy = true,
  ---@type LazyKeysSpec[]
  keys = {
    { [1] = "<C-A-h>", [2] = nil, mode = { "n", "v" }, desc = "vim-move-left" },
    { [1] = "<C-A-j>", [2] = nil, mode = { "n", "v" }, desc = "vim-move-down" },
    { [1] = "<C-A-k>", [2] = nil, mode = { "n", "v" }, desc = "vim-move-up" },
    {
      [1] = "<C-A-l>",
      [2] = nil,
      mode = { "n", "v" },
      desc = "vim-move-right",
    },
  },
  opts = {},
}
