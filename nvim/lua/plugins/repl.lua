local prefix = "<Leader>R"
return {
  dir = "~/Sync/Projects/repl.nvim",
  name = "repl",
  dev = true,
  dependencies = {
    "akinsho/toggleterm.nvim",
  },
  config = function(_, opts)
    local repl = require("repl")
    repl.setup(opts)

    local repl_term = require("repl.repl")
    vim.keymap.set("n", prefix .. "t", repl_term.toggle, {desc = "toggle"})
  end,
}
