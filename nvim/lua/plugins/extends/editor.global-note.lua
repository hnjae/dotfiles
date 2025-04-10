---@type LazySpec
return {
  [1] = "backdround/global-note.nvim",
  version = false,
  lazy = true,
  cond = not vim.g.vscode,

  cmd = { "GlobalNote" },
  opts = {
    directory = vim.fn.stdpath("config"),

    -- A nvim_open_win config to show float window.
    window_config = function()
      local window_height = vim.api.nvim_list_uis()[1].height
      local window_width = vim.api.nvim_list_uis()[1].width
      return {
        relative = "editor",
        border = "rounded",
        title = "Note",
        title_pos = "center",
        width = math.floor(0.7 * window_width),
        height = math.floor(0.85 * window_height),
        row = math.floor(0.05 * window_height),
        col = math.floor(0.15 * window_width),
      }
    end,

    filename = "CHEATSHEET.org",
    title = "CHEATSHEET.org",

    -- TODO: project local CHEATSHEET.org 열게 하기. <2025-04-09>
  },
  keys = {
    { [1] = "<Leader>h", [2] = "<cmd>GlobalNote<CR>", desc = "nvim-help (GlobalNote)" },
  },
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      opts = {
        icons = {
          rules = {
            {
              plugin = "global-note.nvim",
              icon = "", -- nf-fa-sticky_note_o
              color = "orange",
            },
          },
        },
      },
    },
  },
}
