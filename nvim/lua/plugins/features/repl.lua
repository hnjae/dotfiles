return {
  [1] = "hkupty/iron.nvim",
  lazy = false,
  enabled = true,
  cond = not vim.g.vscode,

  -- tag = "v3.0",
  -- commit = "76385183e0fe3ce09d138e10262d74ca2db0ebf5", -- 2022-06-06
  -- commit = "d50dc23331ab217b9e13f47c8d97ea60bd1ab1b7", -- 2022-05-24
  config = function()
    -- local iron = require("iron.core")
    --
    -- local config = {
    --   -- Highlights the last sent block with bold
    --   highlight_last = "IronLastSent",
    --
    --   -- Toggling behavior is on by default.
    --   -- Other options are: `single` and `focus`
    --   visibility = require("iron.visibility").toggle,
    --
    --   -- Scope of the repl
    --   -- By default it is one for the same `pwd`
    --   -- Other options are `tab_based` and `singleton`
    --   scope = require("iron.scope").path_based,
    --
    --   -- Whether the repl buffer is a "throwaway" buffer or not
    --   scratch_repl = false,
    --
    --   -- Automatically closes the repl window on process end
    --   close_window_on_exit = true,
    --   repl_definition = {
    --     -- forcing a default
    --     -- python = require("iron.fts.python").ipython,
    --
    --     -- new, custom repl
    --     lua = {
    --       -- Can be a table or a function that returns a table (see below)
    --       command = { "my-lua-repl", "-arg" },
    --     },
    --   },
    --   -- Whether iron should map the `<plug>(..)` mappings
    --   -- should_map_plug = true,
    --
    --   -- Repl position. Check `iron.view` for more options,
    --   -- currently there are four positions: left, right, bottom, top,
    --   -- the param is the width/height of the float window
    --   repl_open_cmd = require("iron.view").bottom(10),
    --   -- Alternatively, pass a function, which is evaluated when a repl is open.
    --   -- repl_open_cmd = require('iron.view').curry.right(function()
    --   --     return vim.o.columns / 2
    --   -- end),
    --   -- iron.view.curry will open a float window for the REPL.
    --   -- alternatively, pass a string of vimscript for opening a fixed window:
    --   -- repl_open_cmd = 'belowright 15 split',
    --
    --   -- If the repl buffer is listed
    --   buflisted = false,
    -- }
    -- iron.setup({
    --   config = config,
    --
    --   -- All the keymaps are set individually
    --   -- Below is a suggested default
    --   keymaps = {
    --     send_motion = "<space>sc",
    --     visual_send = "<space>sc",
    --     send_file = "<space>sf",
    --     send_line = "<space>sl",
    --     send_mark = "<space>sm",
    --     mark_motion = "<space>mc",
    --     mark_visual = "<space>mc",
    --     remove_mark = "<space>md",
    --     cr = "<space>s<cr>",
    --     interrupt = "<space>s<space>",
    --     exit = "<space>sq",
    --     clear = "<space>cl",
    --   },
    --
    --   -- If the highlight is on, you can change how it looks
    --   -- For the available options, check nvim_set_hl
    --   highlight = {
    --     italic = true,
    --   },
    -- })
    -- -- iron.setup({})
  end,
}
