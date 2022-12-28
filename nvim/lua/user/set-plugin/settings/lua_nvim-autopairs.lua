-- jiangmiao/auto-pairs alternative for Telescope

local M = {}

M.setup = function()
  local status, nvim_autopairs = pcall(require, "nvim-autopairs")

  if not status then
    return
  end
  -- local n_rule = require('nvim-autopairs.rule')

  local opts = {
    -- disable_filetype = { "TelescopePrompt" },
    disable_in_macro = true,  -- disable when recording or executing a macro
    disable_in_visualblock = true, -- disable when insert after visual block mode
    -- ignored_next_char = [=[[%w%%%'%[%"%.]]=],
    -- enable_moveright = true,
    -- enable_afterquote = true,  -- add bracket pairs after quote
    enable_check_bracket_line = false,  --- check bracket in same line
    -- enable_bracket_in_quote = true, --
    -- break_undo = true, -- switch for basic rule break undo sequence
    check_ts = true, -- treesitter
    -- map_cr = true,  -- add indent when new line
    -- map_bs = true,  -- delete paren if BS
    -- map_c_h = false,  -- Map the <C-h> key to delete a pair
    -- map_c_w = false, -- map <c-w> to delete a pair if possible
  }
  nvim_autopairs.setup(opts)
end
return M
