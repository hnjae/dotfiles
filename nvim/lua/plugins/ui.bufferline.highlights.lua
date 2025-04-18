---@type LazySpec
return {
  [1] = "bufferline.nvim",
  optional = true,

  opts = function(_, opts)
    local highlights = {
      fill = {
        fg = {
          attribute = "fg",
          highlight = "TabLineFill",
        },
        bg = {
          attribute = "bg",
          highlight = "TabLineFill",
        },
      },
      tab_selected = {
        fg = {
          attribute = "fg",
          highlight = "TabLineSel",
          bold = true,
        },
        bg = {
          attribute = "bg",
          highlight = "TabLineSel",
        },
      },
      tab = {
        fg = {
          attribute = "fg",
          highlight = "TabLine",
        },
        bg = {
          attribute = "bg",
          highlight = "TabLine",
        },
      },
    }

    highlights.tab_separator_selected = highlights.tab_selected
    highlights.tab_separator = highlights.tab
    highlights.buffer_visible = highlights.tab
    highlights.separator = highlights.tab
    highlights.buffer_selected = highlights.tab_selected
    highlights.separator_selected = highlights.tab_selected

    opts.highlights = vim.tbl_deep_extend("force", opts.highlights or {}, highlights)
    return opts
  end,

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
