local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

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

local keyword_alpha = "p"
return {
  [1] = "goolord/alpha-nvim",
  lazy = true,
  event = { "VimEnter" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    return require("alpha.themes.startify").config
  end,
  main = "alpha",
  config = function(plugin, opts)
    setup_startify()
    require(plugin.main).setup(opts)

    -- 아래가 작동안해서 임시로 추가
    local m = {}
    m[prefix.new .. keyword_alpha] = { name = "+alpha" }
    require("which-key").register(m)
  end,
  keys = {
    {
      -- TODO: 이거 왜 작동 안해? <2024-02-01>
      [1] = prefix.new .. keyword_alpha,
      [2] = nil,
      desc = "+alpha",
    },
    {
      [1] = prefix.new .. keyword_alpha .. map_keyword.tab,
      [2] = function()
        vim.cmd([[
          tab split
          Alpha
          ]])
      end,
      desc = "tab",
    },
    {
      [1] = prefix.new .. keyword_alpha .. map_keyword.split,
      [2] = function()
        vim.cmd([[
          split
          Alpha
          ]])
      end,
      desc = "split",
    },
    {
      [1] = prefix.new .. keyword_alpha .. map_keyword.vsplit,
      [2] = function()
        vim.cmd([[
          vsplit
          Alpha
          ]])
      end,
      desc = "vsplit",
    },
  },
}
