local prefix = require("val").prefix

---@type fun(): nil
local setup_startify = function()
  local startify = require("alpha.themes.startify")
  startify.section.header.val = {}
  -- startify.section.session.val = {
  --   startify.button("qaaaa", "aaaa  Quit NVIM", ":<C-u>qa<CR>"),
  -- }
  startify.section.top_buttons.val = {
    startify.button("e", " New file", "<cmd>enew<CR>"),
    startify.button("s", " Load Sessions", "<cmd>Sload<CR>"),
    -- startify.group(function()vim.notify('aaaaa')end),
  }

  startify.section.bottom_buttons.val = {}
  --   startify.button("q", "  Quit NVIM", "<cmd>qall<CR>"),
  -- }
end

return {
  [1] = "goolord/alpha-nvim",
  -- lazy = false,
  event = { "VimEnter" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    return require("alpha.themes.startify").config
  end,
  config = function(_, opts)
    setup_startify()
    require("alpha").setup(opts)
  end,
  keys = function()
    local suffix = "p"
    --@type LazyKeys[]
    local lazykeys = {
      {
        [1] = prefix.tab .. suffix,
        [2] = function()
          vim.cmd([[
          tab split
          Alpha
          ]])
        end,
        desc = "Alpha",
      },
      {
        [1] = prefix.split .. suffix,
        [2] = function()
          vim.cmd([[
          split
          Alpha
          ]])
        end,
        desc = "Alpha",
      },
      {
        [1] = prefix.vsplit .. suffix,
        [2] = function()
          vim.cmd([[
          vsplit
          Alpha
          ]])
        end,
        desc = "Alpha",
      },
    }
    return lazykeys
  end,
}
