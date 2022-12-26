-- Neovim differences ~

-- neovim doesn't implement some features Vimspector relies on:

-- - WinBar - used for the buttons at the top of the code window and for
  -- changing the output window's current output.

-- - Prompt Buffers - used to send commands in the Console and add Watches.
  -- (_Note_: prompt buffers are available in neovim nightly)

-- - Balloons - this allows for the variable evaluation popup to be displayed
  -- when hovering the mouse. See below for how to create a keyboard mapping
  -- instead.

-- Workarounds are in place as follows:

-- - WinBar - There are mappings, ':VimspectorShowOutput' and ':VimspectorReset'

-- - Prompt Buffers - There are ':VimspectorEval' and ':VimspectorWatch'

-- - Balloons - There is the '<Plug>VimspectorBalloonEval' mapping. There is no
  -- default mapping for this, so I recommend something like this to get
  -- variable display in a popup:
-- >
  -- " mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)

  -- " for normal mode - the word under the cursor
  -- nmap <Leader>di <Plug>VimspectorBalloonEval
  -- " for visual mode, the visually selected text
  -- xmap <Leader>di <Plug>VimspectorBalloonEval

local M = {}

local has_wk, wk = pcall(require, "which-key")
local _DAP_PREFIX = "sd"

local mapping = {
  c = {"<Plug>VimspectorContinue", "continue"},
  s = {"<Plug>VimspectorStop", "stop"},
  R = {"<Plug>VimspectorRestart", "restart"},
  p = {"<Plug>VimspectorPause", "pause"},
  --
  b = {"<Plug>VimspectorToggleBreakpoint", "toggle-line-breakpoint"},
  B = {"<Plug>VimspectorToggleConditionalBreakpoint", "toggle-conditional-line-breakpoint"},
  f = {"<Plug>VimspectorAddFunctionBreakpoint", "add-function-breakpoint"},
  --
  v = {"<Plug>VimspectorStepOver", "step-over"},
  i = {"<Plug>VimspectorStepInto", "step-into"},
  o = {"<Plug>VimspectorStepOut", "step-out"},
  --
  r = {"<Plug>VimspectorRunToCursor", "run-to-cursor"},
}

M.setup = function()
  if has_wk and _IS_PLUGIN("vimspector") then
    wk.register({[_DAP_PREFIX] = {name= "+dap"}}, {})
    wk.register(mapping, {prefix= _DAP_PREFIX})
  end
end

return M
