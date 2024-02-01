local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

---@type LazySpec
return {
  -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
  [1] = "folke/trouble.nvim",
  lazy = true,
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = {
    "Trouble",
    "TroubleClose",
    "TroubleToggle",
  },
  keys = {
    {
      [1] = prefix.focus .. map_keyword.trouble,
      [2] = "<cmd>Trouble<CR>",
      desc = "focus-trouble",
    },
    {
      [1] = prefix.trouble,
      [2] = nil,
      desc = "+trouble",
    },
    {
      [1] = prefix.trouble .. map_keyword.trouble,
      [2] = "<cmd>TroubleToggle<CR>",
      desc = "trouble-toggle",
    },
    {
      [1] = prefix.sidebar .. map_keyword.trouble,
      [2] = "<cmd>TroubleToggle<CR>",
      desc = "trouble-toggle",
    },
    {
      [1] = prefix.trouble .. "w",
      [2] = "<cmd>TroubleToggle workspace_diagnostics<CR>",
      desc = "workspace-diagnostics",
    },
    {
      [1] = prefix.trouble .. "d",
      [2] = "<cmd>TroubleToggle document_diagnostics<CR>",
      desc = "document-diagnostics",
    },
    {
      [1] = prefix.trouble .. "q",
      [2] = "<cmd>TroubleToggle quickfix<CR>",
      desc = "quickfix",
    },
    {
      [1] = prefix.trouble .. "l",
      [2] = "<cmd>TroubleToggle loclist<CR>",
      desc = "location-list",
    },
    {
      [1] = prefix.trouble .. "r",
      [2] = "<cmd>TroubleToggle lsp_references<CR>",
      desc = "lsp-references",
    },
  },
}
