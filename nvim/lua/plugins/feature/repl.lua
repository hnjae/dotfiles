-- ripple: REPL for vim
-- compatible with vim-repeat

local prefix = require("val").prefix

return {
  -- REPL
  [1] = "urbainvaes/vim-ripple",

  lazy = true,
  enabled = false,
  keys = {
    -- NOTE: xmap: Vis O / Sel X <2023-02-15>
    {
      [1] = prefix.repl .. "r",
      [2] = "<Plug>(ripple_send_selection)",
      mode = "x",
      desc = "ripple-send-selection",
    },
    --
    {
      [1] = prefix.repl .. "O",
      [2] = "<Plug>(ripple_open_repl)",
      desc = "Open-repl",
    },
    --
    {
      [1] = prefix.repl .. "m",
      [2] = "<Plug>(ripple_send_motion)",
      desc = "+ripple-motion",
    },
    --
    {
      [1] = prefix.repl .. "p",
      [2] = "<Plug>(ripple_send_previous)",
      desc = "send-previous",
    },
    {
      [1] = prefix.repl .. "l",
      [2] = "<Plug>(ripple_send_line)",
      desc = "send-line",
    },
    {
      [1] = prefix.repl .. "b",
      [2] = "<Plug>(ripple_send_buffer)",
      desc = "send-buffer",
    },
    {
      [1] = prefix.repl .. "L",
      [2] = "<Plug>(ripple_link_term)",
      desc = "link-term",
    },
    -- { "1" .. prefix.repl, [["1]] .. prefix.repl },
    -- { "1" .. prefix.repl .. "l", [["1]] .. prefix.repl .. "l" },
  },
  init = function()
    vim.g.ripple_enable_mappings = 0
    vim.g.ripple_winpos = "vertical"
    -- vim.g.ripple_winpos = "horizontal"
    -- vim.g.ripple_term_name = "term"
    vim.g.ripple_repls = {
      kotlin = "kotlinc",
      javascript = "node",
    }
    vim.g.ripple_term_name = "ripple"
  end,
}
