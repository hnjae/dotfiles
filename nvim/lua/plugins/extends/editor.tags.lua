local cond = vim.fn.executable("ctags") == 1

---@type LazySpec[]
return {
  {
    -- tags 파일 자동 갱신.
    [1] = "ludovicchabant/vim-gutentags",
    lazy = true,
    cond = cond,
    dependencies = {
      "nvim-lua/plenary.nvim", -- using plenary in init function
    },
    init = function()
      vim.g.gutentags_cache_dir =
        require("plenary.path"):new(vim.fn.stdpath("cache"), "gutentags").filename

      vim.g.gutentags_exclude_filetypes = {
        "",
        "NeogitPopup",
        "NeogitStatus",
        "NvimTree",
        "Outline",
        "Trouble",
        "aerial",
        "alpha",
        "checkhealth",
        "dbout",
        "dbui",
        "fugitive",
        "help",
        "nerdtree",
        "noice",
        "qf",
        "snacks_notif",
        "snacks_picker_input",
        "startify",
        "tagbar",
        "toggleterm",
      }
    end,
  },
  {
    [1] = "preservim/tagbar",
    lazy = true,
    cond = cond,
    cmd = {
      "Tagbar",
      "TagbarClose",
      "TagbarCurrentTag",
      "TagbarDebug",
      "TagbarDebugEnd",
      "TagbarForceUpdate",
      "TagbarGetTypeConfig",
      "TagbarJump",
      "TagbarJumpNext",
      "TagbarJumpPrev",
      "TagbarOpen",
      "TagbarOpenAutoClose",
      "TagbarSetFoldlevel",
      "TagbarShowTag",
      "TagbarToggle",
      "TagbarTogglePause",
    },
    dependencies = {
      "vim-gutentags", -- to load gutentags when tagbar loads (not actually a dependency)
      "nvim-lua/plenary.nvim",
    },
    init = function(plugin)
      vim.g.tagbar_width = 30 -- default: 40
      vim.g.tagbar_wrap = 0
      -- vim.g.tagbar_zoomwidth = 0 -- default 1 (use maximum width)
      vim.g.tagbar_indent = 1 -- The number of spaces by which each level is indented.
      vim.g.tagbar_show_data_type = 0
      vim.g.tagbar_help_visibility = 0
      vim.g.tagbar_show_balloon = 1
      vim.g.tagbar_sort = 0 -- 0: sort according to their order in the file

      if plugin.ft ~= nil and #plugin.ft > 0 then
        vim.api.nvim_create_autocmd("FileType", {
          pattern = plugin.ft,
          callback = function(ev)
            if
              vim.api.nvim_buf_line_count(ev.buf) > 80
              and (
                vim.fn.winwidth(0)
                  - (vim.bo.textwidth ~= 0 and vim.bo.textwidth or 80) -- textwidth
                  - 8 -- statuscolumn
                  - 30 -- min aerial width
                >= 0
              )
            then
              vim.cmd("TagbarOpen")
            end
          end,
        })
      end
    end,
    keys = function(plugin, keys)
      return vim.list_extend(keys, {
        {
          [1] = "<Leader>ct",
          [2] = "<cmd>TagbarToggle<CR>",
          desc = "tags (Tagbar)",
          ft = plugin.ft,
          silent = true,
        },
        -- mimic neovim's `[t`
        {
          [1] = "]t",
          [2] = function()
            vim.fn["tagbar#jumpToNearbyTag"](vim.v.count1)
          end,
          ft = plugin.ft,
          desc = "prev-tags",
        },
        {
          [1] = "[t",
          [2] = function()
            vim.fn["tagbar#jumpToNearbyTag"](-vim.v.count1)
          end,
          desc = "prev-tags",
          ft = plugin.ft,
          silent = true,
        },
      })
    end,
    specs = {
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
  },
}
