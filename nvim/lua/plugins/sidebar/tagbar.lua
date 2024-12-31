local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

---@type LazySpec
return {
  [1] = "preservim/tagbar",
  -- lazy = true, -- will be lazy load on filetypes (check `lua/plugins/lang`)
  -- lazy = false,
  enabled = vim.fn.executable("ctags") == 1,
  dependency = {
    "ludovicchabant/vim-gutentags", -- to load gutentags when tagbar loads (not actually a dependency)
  },
  keys = function(plugin, _)
    return {
      {
        [1] = "[" .. map_keyword.tag,
        [2] = "<cmd>TagbarJumpPrev<CR>",
        desc = "prev-tag",
        ft = plugin.ft,
      },
      {
        [1] = "]" .. map_keyword.tag,
        [2] = "<cmd>TagbarJumpNext<CR>",
        desc = "next-tag",
        ft = plugin.ft,
      },
      {
        [1] = prefix.sidebar .. map_keyword.tag,
        [2] = "<cmd>TagbarToggle<CR>",
        desc = "tagbar",
        ft = plugin.ft,
      },
    }
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  init = function()
    vim.g.tagbar_width = 26 -- default: 40
    vim.g.tagbar_wrap = 0
    vim.g.tagbar_zoomwidth = 0 -- default 1 (use maximum width)
    vim.g.tagbar_indent = 1
    vim.g.tagbar_show_data_type = 1
    vim.g.tagbar_help_visiblity = 1
    vim.g.tagbar_show_balloon = 1
  end,
  config = function() end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          tagbar = { display_name = "Tagbar", icon = icons.tag },
        })
      end,
    },
    {
      [1] = "ludovicchabant/vim-gutentags",
      lazy = true, -- will be loaded by tagbar
      enabled = false,
      dependencies = {
        "nvim-lua/plenary.nvim", -- using plenary in init function
      },
      init = function()
        vim.g.gutentags_cache_dir = require("plenary.path"):new(
          vim.fn.stdpath("cache"),
          "gutentags"
        ).filename

        vim.g.gutentags_exclude_filetypes = {
          "",
          "fugitive",
          "NeogitStatus",
          "NeogitPopup",
          "nerdtree",
          "NvimTree",
          "tagbar",
          "Outline",
          "help",
          "startify",
          "alpha",
          "Trouble",
          "noice",
          "checkhealth",
          "qf",
          "dbui",
          "dbout",
        }
      end,
    },
    -- {
    --   [1] = "hrsh7th/nvim-cmp",
    --   optional = true,
    --   dependencies = {
    --     {
    --       [1] = "quangnguyen30192/cmp-nvim-tags",
    --     },
    --   },
    --   opts = function(_, opts)
    --     local source = {
    --       name = "tags",
    --       group_index = 1,
    --       -- option = {
    --       --   -- this is the default options, change them if you want.
    --       --   -- Delayed time after user input, in milliseconds.
    --       --   complete_defer = 100,
    --       --   -- Max items when searching `taglist`.
    --       --   max_items = 10,
    --       --   -- Use exact word match when searching `taglist`, for better searching
    --       --   -- performance.
    --       --   exact_match = false,
    --       --   -- Prioritize searching result for current buffer.
    --       --   current_buffer_only = false,
    --       -- },
    --     }
    --     table.insert(opts.sources, source)
    --     require("utils.plugin").on_load("nvim-cmp", function()
    --       -- NOTE: 이 방식이면 tag 만뜸, 외부 state 에 뭐 하나 만들어서, 거기에서
    --       -- 처리해야할 것 같다. <2024-04-17>
    --       require("cmp").setup.filetype(fts, {
    --         sources = {
    --           source,
    --         },
    --       })
    --     end)
    --   end,
    -- },
  },
}
