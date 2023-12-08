-- ripple: REPL for vim
-- compatible with vim-repeat

local prefix = require("val").prefix

return {
  -- REPL
  "urbainvaes/vim-ripple",

  lazy = true,
  enabled = false,
  keys = {
    -- NOTE: xmap: Vis O / Sel X <2023-02-15>
    { prefix.repl .. "r", "<Plug>(ripple_send_selection)", mode = "x", desc = "ripple-send-selection" },
    --
    { prefix.repl .. "O", "<Plug>(ripple_open_repl)", desc = "Open-repl" },
    --
    { prefix.repl .. "m", "<Plug>(ripple_send_motion)", desc = "+ripple-motion" },
    --
    { prefix.repl .. "p", "<Plug>(ripple_send_previous)", desc = "send-previous" },
    { prefix.repl .. "l", "<Plug>(ripple_send_line)", desc = "send-line" },
    { prefix.repl .. "b", "<Plug>(ripple_send_buffer)", desc = "send-buffer" },
    { prefix.repl .. "L", "<Plug>(ripple_link_term)", desc = "link-term" },
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
      javascript = "node"
    }
    vim.g.ripple_term_name = "ripple"
  end,
}
