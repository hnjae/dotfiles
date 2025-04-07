---@type LazySpec
return {
  [1] = "ibhagwan/fzf-lua",
  optional = true,
  keys = {
    { [1] = "<F1>", [2] = "<cmd>FzfLua helptags<CR>", desc = "help-tags" },
  },
  opts = function()
    local fzf = require("fzf-lua")
    local config = fzf.config
    local actions = fzf.actions

    -- restore fzf-lua's default mapping
    config.defaults.actions.files["ctrl-t"] = actions.file_tabedit

    -- move trobule else where
    if LazyVim.has("trouble.nvim") then
      config.defaults.actions.files["ctrl-z"] = require("trouble.sources.fzf").actions.open
    end
  end,
}
