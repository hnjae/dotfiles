local wk_icon = { icon = "󰩫 ", color = "red" }

---@type LazySpec
return {
  [1] = "chrisgrieser/nvim-scissors",
  version = false,

  lazy = true,
  cmd = {
    "ScissorsAddNewSnippet",
    "ScissorsEditSnippet",
  },
  keys = {
    {
      [1] = "<Leader>sp",
      [2] = "<cmd>ScissorsEditSnippet<CR>",
      mode = "n",
      desc = "scissors-edit-snippet",
    },
    {
      [1] = "<S-F4>", -- Shift + F4, 작동 안되는디..
      mode = "n",
      [2] = "<cmd>ScissorsAddNewSnippet<CR>",
      desc = "scissors-add-new-snippet",
    },
  },
  opts = {
    snippetDir = vim.fn.stdpath("config") .. "/snippets",
    snippetSelection = {
      -- picker = "vim.ui.select", -- vim.ui.select won't support preview
    },
    icons = {
      scissors = wk_icon.icon,
    },
  },
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      -- ---@type wk.Opts
      opts = {
        icons = {
          rules = {
            { plugin = "nvim-scissors", icon = wk_icon.icon, color = wk_icon.color },
          },
        },
        spec = {},
      },
    },
  },
}
