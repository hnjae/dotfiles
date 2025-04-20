local icons = require("globals").icons
---@type LazySpec
return {
  [1] = "which-key.nvim",
  opts_extend = { "spec", "icons.rules" },
  optional = true,
  opts = {
    ---@type wk.Spec[]
    -- stylua: ignore
    spec = {
      -- Add missing icon from LazyVim v14.14.0 (2025-04-09)
      -- <https://neovim.io/doc/user/options.html#'keywordprg'>
      { [1] = "<Leader>K", mode = { "n" }, icon = { icon = " ", color = "yellow" } }, -- nf-cod-question
      { [1] = "[e", mode = { "n" }, icon = { icon = " ", color = "red" } },
      { [1] = "]e", mode = { "n" }, icon = { icon = " ", color = "red" } },
      { [1] = "[w", mode = { "n" }, icon = { icon = " ", color = "orange" } },
      { [1] = "]w", mode = { "n" }, icon = { icon = " ", color = "orange" } },

      -- Add missing icon from neovim
      { [1] = "[s", icon = { icon = "󰓆 " }, desc = "prev-misspelled" }, -- nf-md-spellcheck
      { [1] = "]s", icon = { icon = "󰓆 " }, desc = "next-misspelled" }, -- nf-md-spellcheck
      { [1] = "[m", icon = { icon = " " }, desc = "prev-method" },
      { [1] = "[M", icon = { icon = " " }, desc = "prev-method-end" },
      { [1] = "]m", icon = { icon = " " }, desc = "prev-method" },
      { [1] = "]M", icon = { icon = " " }, desc = "prev-method-end" },
      { [1] = "[ ", icon = { icon = " " }, desc = "insert-empty-line-above-cursor" }, -- nf-cod-insert
      { [1] = "] ", icon = { icon = " " }, desc = "insert-empty-line-below-cursor" }, -- nf-cod-insert

      { [1] = "g,", icon = { icon = "󰆾 " }, desc = "goto-[count]-newer-position-in-change-list", }, -- nf-md-cursor_move
      { [1] = "g;", icon = { icon = "󰆾 " }, desc = "goto-[count]-older-position-in-change-list", }, -- nf-md-cursor_move
      { [1] = "gE", icon = { icon = "󰌍 " }, desc = "prev-end-of-WORD" }, -- nf-md-keyboard_backspace
      { [1] = "gO", icon = { icon = " " }, desc = "quickfix-outline (lsp)" }, -- nf-cod-symbol_class
      { [1] = "gT", icon = { icon = "󱞧 " }, desc = "goto-prev-tab" },
      { [1] = "gU", icon = { icon = "󰬶 " }, desc = "uppercase" }, -- nf-md-format_letter_case_upper
      { [1] = "ge", icon = { icon = "󰌍 " }, desc = "prev-end-of-word" }, -- nf-md-keyboard_backspace
      { [1] = "gg", icon = { icon = "󰞕 " }, desc = "goto-first-line" }, -- nf-md-arrow_collapse_up
      { [1] = "gi", icon = { icon = "󰗧 " }, desc = "goto-last-insert" }, -- nf-md-cursor_text
      { [1] = "gt", icon = { icon = "󱞫 " }, desc = "goto-next-tab" }, -- nf-md-arrow_right_top
      { [1] = "gu", icon = { icon = "󰬵 " }, desc = "lowercase" }, -- nf-md-format_letter_case_lower
      { [1] = "gv", icon = { icon = "󰩭 " }, desc = "Last visual selection" }, -- nf-md-selection_drag
      { [1] = "gx", icon = { icon = "󰏌 " }, desc = "Open with system app" }, -- nf-md-open_in_new:w
      { [1] = "g~", icon = { icon = "󰬵 " }, desc = "toggle-case" }, -- nf-md-format_letter_case_lower

      { [1] = "0", icon = { icon = "󰘀 " }, mode = {"n", "v"}, desc = "start-of-line" }, -- nf-md-page_first
      { [1] = "G", icon = { icon = "󰞒 " }, mode = {"n", "v"}, desc = "last-line" }, -- nf-md-page_first
      { [1] = "c", icon = { icon = "󰬳 " }, mode = {"n", "v"}, desc = "change" },
      { [1] = "d", icon = { icon = "󰇾 " }, mode = {"n", "v"}, desc = "delete" }, -- nf-md-eraser
      { [1] = "h", icon = { icon = "󰅁 " }, mode = {"n", "v"}, desc = "left" },
      { [1] = "j", icon = { icon = "󰅀 " }, mode = {"n", "v"}, desc = "down" },
      { [1] = "k", icon = { icon = "󰅃 " }, mode = {"n", "v"}, desc = "up" },
      { [1] = "l", icon = { icon = "󰅂 " }, mode = {"n", "v"}, desc = "right" },
      { [1] = "r", icon = { icon = "󰬳 " }, mode = {"n", "v"}, desc = "replace" }, -- nf-md-file_replace_outline
      { [1] = "y", icon = { icon = "󰆏 " }, mode = {"n", "v"}, desc = "yank" }, -- nf-md-content_copy
    },
    ---@type wk.IconRule[]
    icons = {
      rules = {
        -- add new pattern
        -- { pattern = "prev", icon = "󰄽 ", color = "grey" },
        -- { pattern = "next", icon = "󰄾 ", color = "grey" },
        { pattern = "fold", icon = " ", color = "grey" }, -- nf-cod-fold

        -- override defaults rules
        { pattern = "file", icon = "󰈤 ", color = "cyan" }, -- nf-md-file_outline
        -- { pattern = "buffer", icon = "󱇨 ", color = "cyan" }, -- nf-md-file_edit_outline
        { pattern = "buffer", icon = "󰈔 ", color = "cyan" }, -- nf-md-file
        { pattern = "format", icon = icons.sort, color = "cyan" },

        { pattern = "find", icon = icons.search, color = "green" },
        { pattern = "search", icon = icons.search, color = "green" },
        { pattern = "debug", icon = " ", color = "red" }, -- nf-cod-debug

        { pattern = "%f[%a]ai", icon = icons.ai, color = "green" }, -- nf-md-robot_outline
        { pattern = "code", icon = "󰅴 ", color = "orange" }, -- nf-md-code_tags
        { pattern = "toggle", icon = icons.toggle, color = "yellow" }, -- nf-md-toggle_switch_outline
      },
    },
  },
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = {
          "which-key.nvim",
        },
      },
    },
  },
}
