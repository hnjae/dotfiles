-- LazyExtra's ai.sidekick

---@type LazySpec
return {
  [1] = "sidekick.nvim",
  cond = not vim.g.vscode,
  opts = function(_)
    local backend = vim.tbl_contains({ "tmux" }, vim.env.TERM_PROGRAM) and vim.env.TERM_PROGRAM
      or nil

    return {
      cli = {
        mux = {
          backend = backend,
          enabled = backend ~= nil, -- Disable mux if no multiplexer detected

          -- terminal: new sessions will be created for each CLI tool and shown in a Neovim terminal
          -- window: when run inside a terminal multiplexer, new sessions will be created in a new tab
          -- split: when run inside a terminal multiplexer, new sessions will be created in a new split
          create = backend ~= nil and "split" or "terminal",
        },
      },
    }
  end,
}
