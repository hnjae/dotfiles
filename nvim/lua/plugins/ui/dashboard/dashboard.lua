-- local keyword_alpha = "p"

---@type LazySpec
return {
  [1] = "nvimdev/dashboard-nvim",
  lazy = false,
  -- event = { "VimEnter" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    theme = "doom",
    config = {
      packages = { enable = false },
    },
  },
  -- opts = function()
  --   return vim.tbl_deep_extend(
  --     "force",
  --     -- require("alpha.themes.dashboard").config,
  --     require("alpha.themes.startify").config,
  --     {
  --       nvim_web_devicons = {
  --         enabled = require("utils").enable_icon,
  --       },
  --     }
  --   )
  -- end,
  -- main = "alpha",
  -- config = function(plugin, opts)
  --   local startify = require("alpha.themes.startify")
  --   --
  --   -- local enable_icon = require("utils").enable_icon
  --   -- startify.section.header.val = {}
  --   -- startify.section.top_buttons.val = {
  --   --   startify.button(
  --   --     "e",
  --   --     enable_icon
  --   --         and string.format("%s  %s", require("val").icons.file, "New File")
  --   --       or "New File",
  --   --     "<cmd>enew<CR>"
  --   --   ),
  --   --   startify.button(
  --   --     "s",
  --   --     enable_icon and string.format("%s  %s", "", "Load Sessions")
  --   --       or "Load Sessions",
  --   --     "<cmd>Sload<CR>"
  --   --   ),
  --   -- }
  --   -- startify.section.bottom_buttons.val = {}
  --
  --   -- require(plugin.main).setup(opts)
  --   -- require(plugin.main).setup(startify.config)
  --   require("alpha").setup(require("alpha.themes.startify").config)
  --
  --   -- 아래가 작동안해서 임시로 추가
  --   -- local m = {}
  --   -- m[prefix.new .. keyword_alpha] = { name = "+alpha" }
  --   -- require("which-key").register(m)
  -- end,
  -- keys = {
  --   {
  --     -- TODO: 이거 왜 작동 안해? <2024-02-01>
  --     [1] = prefix.new .. keyword_alpha,
  --     [2] = nil,
  --     desc = "+alpha",
  --   },
  --   {
  --     [1] = prefix.new .. keyword_alpha .. map_keyword.tab,
  --     [2] = function()
  --       vim.cmd([[
  --         tab split
  --         Alpha
  --         ]])
  --     end,
  --     desc = "tab",
  --   },
  --   {
  --     [1] = prefix.new .. keyword_alpha .. map_keyword.split,
  --     [2] = function()
  --       vim.cmd([[
  --         split
  --         Alpha
  --         ]])
  --     end,
  --     desc = "split",
  --   },
  --   {
  --     [1] = prefix.new .. keyword_alpha .. map_keyword.vsplit,
  --     [2] = function()
  --       vim.cmd([[
  --         vsplit
  --         Alpha
  --         ]])
  --     end,
  --     desc = "vsplit",
  --   },
  -- },
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          dashboard = { display_name = "Dashboard", icon = icons.dashboard },
        })
      end,
    },
  },
}
