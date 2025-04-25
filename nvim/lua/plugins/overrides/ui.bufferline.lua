--[[
NOTE:

Always show tab indicators:
  - <https://github.com/akinsho/bufferline.nvim/pull/1008> 2025-03-30
]]
---@type LazySpec[]
return {
  {
    [1] = "bufferline.nvim",
    optional = true,
    opts = {
      options = {
        style_preset = {
          require("bufferline").style_preset.no_italic,
          require("bufferline").style_preset.no_bold,
          -- require("bufferline").style_preset.minimal,
        },
        -- single buffer with multiple tabs won't show bufferline by default (2025-04-08)
        always_show_bufferline = true,

        modified_icon = "", --nf-cod-circle_filled
        buffer_close_icon = "×", -- unicode (multiplication sign)
        close_icon = "󰅖", -- nf-md-close
        -- left_trunc_marker = " ",-- default
        -- right_trunc_marker = " ",-- default

        show_tab_indicators = true,
        pick = {
          -- alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
          alphabet = "ntesiroahduflpywNTESIROAHDUFLPYW",
        },
      },

      highlights = {
        -- gruvbox light 에서 정상적으로 작동하도록 추가 <2025-04-18>
        tab_selected = {
          fg = {
            attribute = "fg",
            highlight = "Normal",
            bold = true,
          },
          bg = {
            attribute = "bg",
            highlight = "Normal",
          },
        },
      },
    },

    keys = {
      { "<Leader>bs", "<cmd>BufferLineSortByTabs<CR>", desc = "sort-by-tabs" },
      -- new key map
      {
        [1] = "<Leader><Tab>r",
        [2] = function()
          vim.ui.input({ prompt = "Rename tab: " }, function(name)
            if name then
              vim.cmd("BufferLineTabRename " .. name)
            end
          end)
        end,
        desc = "tab-rename",
      },
    },
  },

  -- HACK: hacky way to customize the pinned icon <2025-04-18>
  -- NOTE:
  -- <https://github.com/akinsho/bufferline.nvim/issues/981>
  -- pinned buffer icon is not customizable via config
  {
    [1] = "bufferline.nvim",
    optional = true,
    opts = function()
      local groups = require("bufferline.groups")
      groups.builtin.pinned.icon = "󰤱" -- nf-md-pin
      -- groups.builtin.pinned.icon = "󰍁" -- nf-md-lock_outline
      -- groups.builtin.pinned.icon = "󰓒" -- nf-md-lock_outline
    end,
  },
}
