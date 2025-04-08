local root_terminal = Snacks.terminal.get(nil, { cwd = LazyVim.root() })

---@type LazySpec
return {
  [1] = "folke/snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {},
  specs = {},
  keys = {
    {
      [1] = "<Leader>ft",
      [2] = function()
        if root_terminal == nil then
          vim.notify("Snacks terminal not found")
        end

        root_terminal.toggle()
      end,
      desc = "Terminal (Root Dir)",
    },
    {
      [1] = "<Leader>fT",
      [2] = Snacks.terminal.toggle,
      desc = "Terminal (CWD)",
    },
  },
}
