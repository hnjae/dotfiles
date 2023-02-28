return {
  "michaelb/sniprun",
  lazy = true,
  version = "v1.2.x",
  -- build sniprun from source
  build = "bash ./install.sh 1",
  dependencies = {
    "rcarriga/nvim-notify",
  },
  opts = {
    -- repl_enable = { "Python3_original" },
    display = {
      "VirtualTextOk",
      -- "TempFloatingWindow",
      "NvimNotify",
    },
  },
  cmd = {
    "SnipRun",
    "SnipInfo",
    "SnipReset",
    "SnipReplMemoryClean",
    "SnipClose",
    "SnipLive",
  },
  keys = function()
    local prefix = require("val").prefix

    ---@type LazyKeys[]
    local lazykeys = {
      {
        prefix.sniprun,
        "<Plug>SnipRun",
        mode = { "v" },
        desc = "v-sniprun",
      },
      {
        prefix.sniprun .. "f",
        "<Plug>SnipRun",
        mode = { "n" },
        desc = "line",
      },
      {
        prefix.sniprun .. "i",
        "<Plug>SnipInfo",
        mode = { "n" },
        desc = "info",
      },
      {
        prefix.sniprun .. "r",
        "<Plug>SnipReset",
        mode = { "n" },
        desc = "reset",
      },
      {
        prefix.sniprun .. "c",
        "<Plug>SnipReplMemoryClean",
        mode = { "n" },
        desc = "clear-repl",
      },
      {
        prefix.close .. "s",
        "<Plug>SnipClose",
        mode = { "n" },
        desc = "close",
      },
      {
        prefix.sniprun .. "t",
        "<Plug>SnipRun",
        mode = { "n" },
        desc = "live-toggle",
      },
      {
        prefix.sniprun,
        "<Plug>SnipRunOperator",
        mode = { "n" },
        desc = "operator",
      },
    }

    return lazykeys
  end,
}
