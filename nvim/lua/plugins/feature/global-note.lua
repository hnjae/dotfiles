---@type LazySpec
return {
  [1] = "backdround/global-note.nvim",
  lazy = true,
  cmd = { "GlobalNote" },
  opts = function()
    return {
      directory = require("plenary.path"):new(
        vim.fn.stdpath("config"),
        "resources",
        "global-note"
      ).filename,

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

      -- additional_presets = {
      --   readme = {
      --     filename = "README.md",
      --     title = "README",
      --   },
      -- },
    }
  end,
  keys = function()
    -- local gnote = require("global-note")
    -- local prefix = require("val").prefix
    -- local map_keyword = require("val").map_keyword

    return {
      { [1] = "<Leader>h", [2] = "<cmd>GlobalNote<CR>", desc = "nvim-help" },
    }
  end,
}
