--[[
  - 다이나믹한 창 크기 조절
  - CTRL-W_bar, CTRL-W_, CTRL-W_= 설정
]]

---@type LazySpec
return {
  [1] = "anuvyklack/windows.nvim",
  event = "WinNew",
  lazy = true,
  cond = not vim.g.vscode,
  dependencies = {
    { "anuvyklack/middleclass" },
    { [1] = "anuvyklack/animation.nvim", enabled = false },
  },
  keys = {
    --[[
      참고:
      > * **zen:** zoom with leader-wm and leader-uZ. zen with leader-uz ([2acedaa](https://github.com/LazyVim/LazyVim/commit/2acedaa3a8312e53d84a299bd82d616e1c26328a))
    --]]
    {
      [1] = "<leader>uW",
      [2] = function()
        vim.notify("Toggled Windows-AutoWidth")
        vim.cmd("WindowsToggleAutowidth")
      end,
      desc = "Toggle Autowidth (windows.nvim)",
    },
  },
  opts = {
    ignore = {
      buftype = {
        "picker",
        "prompt",
        "nofile",
        "nowrite",
        "quickfix",
        "terminal",
      },
      filetype = {
        "notify",
        "noice",
        "TelescopePrompt",
        "lazy",
        "tagbar",
        "fzf",
        "OverseerList",
        "Outline",
        "toggleterm",
        "NvimTree",
        "alpha",
      },
    },
    animation = {
      enable = false,
    },
  },
  config = function(_, opts)
    require("windows").setup(opts)

    -- local del_cmds = {
    --   -- "WindowsMaximize",
    --   -- "WindowsMaximizeVertically",
    --   -- "WindowsMaximizeHorizontally",
    -- }
    --
    -- for idx, cmd in ipairs(del_cmds) do
    --   vim.api.nvim_del_user_command(cmd)
    -- end
  end,
}
