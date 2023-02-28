---@type fun(): nil
local setup_startify = function()
  local startify = require("alpha.themes.startify")
  startify.section.header.val = {}
  -- startify.section.session.val = {
  --   startify.button("qaaaa", "aaaa  Quit NVIM", ":<C-u>qa<CR>"),
  -- }
  startify.section.top_buttons.val = {
    startify.button("e", "  New file", "<cmd>ene<CR>"),
    startify.button("s", "Load Sessions", "<cmd>SSLoad<CR>"),
    -- startify.group(function()vim.notify('aaaaa')end),
  }
  startify.section.bottom_buttons.val = {
    startify.button("q", "  Quit NVIM", "<cmd>qall<CR>"),
  }
end

return {
  "goolord/alpha-nvim",
  -- lazy = true,
  -- event = {"VimEnter"},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    return require("alpha.themes.startify").config
  end,
  config = function(_ , opts)
    setup_startify()
    require("alpha").setup(opts)
  end,
}
