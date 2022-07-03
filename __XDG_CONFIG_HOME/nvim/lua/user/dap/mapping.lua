local M = {}
local has_dap, dap = pcall(require, "dap")
local has_wk, wk = pcall(require, "which-key")

local has_dap_python, dap_python require('dap-python')

if not has_dap or not has_wk then
  return M
end

local dap_prefix = "_LANG_PREFIX" .. "d"
local mapping = {
  c = { dap.continue, "continue" },
  s = { name = "+step" },
  sv = { dap.step_over, "step-over" },
  si = { dap.step_into, "step-into" },
  so = { dap.step_into, "step-out" },
  b = { dap.toggle_breakpoint, "toggle-breakpoint" },
  B = { "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", "set-breakpoint-cond" },
  v = { "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", "set-breakpoint-log" },

  r = { dap.repl.open, "repl-open" },
  l = { dap.run_last, "run-last" },

}
M.setup = function (bufnr)
  wk.register(
    { [dap_prefix] = { name = "dap" }},
    { buffer = bufnr, noremap=false, mode = "n" }
  )
  wk.register(mapping, { buffer = bufnr, noremap=false, mode = "n", prefix = dap_prefix })

  if has_dap_python then
    dap_python.test_runner = "pytest"
  end
end
return M
