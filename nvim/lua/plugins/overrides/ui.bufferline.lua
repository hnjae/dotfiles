--[[
NOTE:

Always show tab indicators:
  - <https://github.com/akinsho/bufferline.nvim/pull/1008>
]]
---@type LazySpec
return {
  [1] = "bufferline.nvim",
  optional = true,

  opts = {
    options = {
      -- single buffer with multiple tabs won't show bufferline by default (2025-04-08)
      always_show_bufferline = true,

      modified_icon = "", --nf-cod-circle_filled
      buffer_close_icon = "󰅖", -- nf-md-close
      close_icon = "󰅖", -- nf-md-close
      -- left_trunc_marker = " ",-- default
      -- right_trunc_marker = " ",-- default

      show_tab_indicators = true,
      pick = {
        -- alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
        alphabet = "ntesiroahduflpywNTESIROAHDUFLPYW",
      },
    },
  },

  -- disable lazyvim's mapping
  keys = {
    { "<S-h>", "<Nop>" },
    { "<S-l>", "<Nop>" },

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
}
