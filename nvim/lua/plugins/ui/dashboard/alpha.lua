local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

local keyword_alpha = "p"

---@type LazySpec
return {
  [1] = "goolord/alpha-nvim",
  lazy = false,
  event = { "VeryLazy" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  main = "alpha",
  config = function(plugin, _)
    local startify = require("alpha.themes.startify")
    local enable_icon = require("utils").enable_icon

    startify.nvim_web_devicons.enabled = enable_icon

    startify.section.header.val = { "Hi!" }
    startify.section.top_buttons.val = {
      startify.button("e", enable_icon and string.format(
        "%s  %s",
        -- require("utils.get-icon")(nil, nil, "terminal"),
        require("val").icons.file,
        "New File"
      ) or "New File", "<cmd>enew<CR>"),
      startify.button(
        "s",
        enable_icon and string.format("%s  %s", "", "Load Sessions")
          or "Load Sessions",
        "<cmd>Sload<CR>"
      ),
    }

    -- require(plugin.main).setup(require("alpha.themes.startify").config)
    require(plugin.main).setup(startify.config)
  end,
  keys = {
    {
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
