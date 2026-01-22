-- LazyExtra's ai.sidekick

---@type LazySpec
return {
  [1] = "sidekick.nvim",
  cond = not vim.g.vscode,
  opts = {
    nes = { enabled = false }, -- NES 는 리팩토링 용도. copilot 과는 목적이 다르다고.
  },
  -- opts = function(_)
  --   local backend = vim.tbl_contains({ "tmux" }, vim.env.TERM_PROGRAM) and vim.env.TERM_PROGRAM
  --     or nil
  --
  --   return {
  --     nes = { enabled = false },
  --     cli = {
  --       mux = {
  --         backend = backend,
  --         enabled = backend ~= nil, -- Disable mux if no multiplexer detected
  --
  --         -- terminal: new sessions will be created for each CLI tool and shown in a Neovim terminal
  --         -- window: when run inside a terminal multiplexer, new sessions will be created in a new tab
  --         -- split: when run inside a terminal multiplexer, new sessions will be created in a new split
  --         create = backend ~= nil and "split" or "terminal",
  --       },
  --     },
  --   }
  -- end,
}
