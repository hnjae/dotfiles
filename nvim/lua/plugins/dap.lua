return {
  ------------------------------------------------------------------------------
  -- dap
  ------------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function()
      local dap = require("dap")
      local wk = require("which-key")

      local mapping = {
        name = "+dap",
        c = { dap.continue, "continue" },
        s = { name = "+step" },
        sv = { dap.step_over, "step-over" },
        si = { dap.step_into, "step-into" },
        so = { dap.step_into, "step-out" },
        b = { dap.toggle_breakpoint, "toggle-breakpoint" },
        -- B = { dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')), "set-breakpoint-cond" },
        -- v = { dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')), "set-breakpoint-log" },
        r = { dap.repl.open, "repl-open" },
        l = { dap.run_last, "run-last" },
      }
      wk.register(mapping, { noremap = false, mode = "n", prefix = _MAPPING_PREFIX["lang"] .. "d" })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    opts = {},
  },
}
