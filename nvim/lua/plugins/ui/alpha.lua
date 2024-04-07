local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

local keyword_alpha = "p"
return {
  [1] = "goolord/alpha-nvim",
  lazy = true,
  event = { "VimEnter" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    return vim.tbl_deep_extend(
      "force",
      -- require("alpha.themes.dashboard").config,
      require("alpha.themes.startify").config,
      {
        nvim_web_devicons = {
          enabled = require("utils").enable_icon,
        },
      }
    )
  end,
  main = "alpha",
  config = function(plugin, opts)
    local startify = require("alpha.themes.startify")
    -- local devicons = require("nvim-web-devicons")

    local enable_icon = opts.nvim_web_devicons.enabled
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

    require(plugin.main).setup(opts)

    -- 아래가 작동안해서 임시로 추가
    -- local m = {}
    -- m[prefix.new .. keyword_alpha] = { name = "+alpha" }
    -- require("which-key").register(m)
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
