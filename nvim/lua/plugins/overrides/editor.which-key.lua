---@type LazySpec
return {
  [1] = "which-key.nvim",
  opts_extend = { "spec", "icons.rules" },
  optional = true,

  dependencies = {
    { [1] = "LazyVim", optional = true }, -- to use LazyVim's icons
  },
  ---@param opts wk.Opts
  opts = function(_, opts)
    local icons = require("globals").icons

    local licons = {
      prev = "󰶢 ",
      next = "󰔰 ",
    }

    -- ---@type wk.Spec[]
    -- stylua: ignore
    opts.spec = vim.list_extend(opts.spec or {}, {
      -- Add missing icon from LazyVim v14.14.0 (2025-04-09)
      -- <https://neovim.io/doc/user/options.html#'keywordprg'>
      { [1] = "<Leader>K", mode = { "n" }, icon = { icon = " ", color = "yellow" } }, -- nf-cod-question
      { [1] = "[e", mode = { "n" }, icon = { icon = " ", color = "red" } },
      { [1] = "]e", mode = { "n" }, icon = { icon = " ", color = "red" } },
      { [1] = "[w", mode = { "n" }, icon = { icon = " ", color = "orange" } },
      { [1] = "g[", mode = { "n", "x", "o" }, icon = { icon = licons.prev } }, -- mini.ai
      { [1] = "g]", mode = { "n", "x", "o" }, icon = { icon = licons.next } }, -- mini.ai

      ----------------------------------------------------------------------------------------------
      -- Add missing icon from neovim
      ----------------------------------------------------------------------------------------------
      { [1] = "[ ", icon = { icon = " " }, desc = "insert-empty-line-above-cursor" }, -- nf-cod-insert
      { [1] = "] ", icon = { icon = " " }, desc = "insert-empty-line-below-cursor" }, -- nf-cod-insert

      { [1] = "gO", icon = { icon = " " }, desc = "quickfix-outline (lsp)" }, -- nf-cod-symbol_class
      { [1] = "gi", icon = { icon = "󰗧 " }, desc = "goto-last-insert" }, -- nf-md-cursor_text
      { [1] = "gv", icon = { icon = "󰩭 " }, desc = "Last visual selection" }, -- nf-md-selection_drag
      { [1] = "gx", icon = { icon = "󰏌 " }, desc = "Open with system app" }, -- nf-md-open_in_new:w

      { [1] = "g,", icon = { icon = "󰆾 " }, desc = "goto-[count]-newer-position-in-change-list", }, -- nf-md-cursor_move
      { [1] = "g;", icon = { icon = "󰆾 " }, desc = "goto-[count]-older-position-in-change-list", }, -- nf-md-cursor_move

      { [1] = "gt", icon = { icon = "󱞫 " }, desc = "goto-next-tab" }, -- nf-md-arrow_right_top
      { [1] = "gT", icon = { icon = "󱞧 " }, desc = "goto-prev-tab" },

      { [1] = "gU", icon = { icon = "󰬶 " }, desc = "uppercase" }, -- nf-md-format_letter_case_upper
      { [1] = "gu", icon = { icon = "󰬵 " }, desc = "lowercase" }, -- nf-md-format_letter_case_lower
      { [1] = "g~", icon = { icon = "󰬵 " }, desc = "toggle-case" }, -- nf-md-format_letter_case_lower

      { [1] = "%",  icon = { icon = "󰾹 " }, desc = "cycle-forward-through-results" }, -- nf-md-format_letter_matches
      { [1] = "g%", icon = { icon = "󰾹 " }, desc = "cycle-backwards-through-results" }, -- nf-md-format_letter_matches

      -- motion
      { [1] = "[",  icon = { icon = licons.prev }, mode = { "n", "x" }, desc = "+prev" },
      { [1] = "]",  icon = { icon = licons.next }, mode = { "n", "x" }, desc = "+next" },

      { [1] = "[s", icon = { icon = "󰓆 " }, mode = { "n", "x" }, desc = "prev-misspelled" }, -- nf-md-spellcheck
      { [1] = "]s", icon = { icon = "󰓆 " }, mode = { "n", "x" }, desc = "next-misspelled" }, -- nf-md-spellcheck

      { [1] = "[m", icon = { icon = LazyVim.config.icons.kinds.Method }, mode = { "n", "x" }, desc = "prev-method" },
      { [1] = "[M", icon = { icon = LazyVim.config.icons.kinds.Method }, mode = { "n", "x" }, desc = "prev-method-end" },
      { [1] = "]m", icon = { icon = LazyVim.config.icons.kinds.Method }, mode = { "n", "x" }, desc = "prev-method" },
      { [1] = "]M", icon = { icon = LazyVim.config.icons.kinds.Method }, mode = { "n", "x" }, desc = "prev-method-end" },

      { [1] = "gg", icon = { icon = "󰞕 " }, mode = { "n", "x" }, desc = "goto-first-line" }, -- nf-md-arrow_collapse_up
      { [1] = "G", icon = { icon = "󰞒 " }, mode = { "n", "x" }, desc = "last-line" }, -- nf-md-page_first

      { [1] = "0",      icon = { icon = "󰘀 " }, mode = { "n", "x" }, desc = "start-of-line" }, -- nf-md-page_first
      { [1] = "<Home>", icon = { icon = "󰘀 " }, mode = { "n", "x" }, desc = "start-of-line" }, -- nf-md-page_first
      { [1] = "$",      icon = { icon = "󰘁 " }, mode = { "n", "x" }, desc = "end-of-line" }, -- nf-md-page_last
      { [1] = "<End>",  icon = { icon = "󰘁 " }, mode = { "n", "x" }, desc = "end-of-line" }, -- nf-md-page_last

      { [1] = "^",  icon = { icon = licons.prev }, mode = { "n", "x" }, desc = "first-non-blank-char" },
      { [1] = "g_", icon = { icon = licons.next }, mode = { "n", "x" }, desc = "last-non-blank-char" },
      { [1] = "(",  icon = { icon = licons.prev }, mode = { "n", "x" }, desc = "prev-sentence" },
      { [1] = ")",  icon = { icon = licons.next }, mode = { "n", "x" }, desc = "next-sentence" },
      { [1] = "{",  icon = { icon = licons.prev }, mode = { "n", "x" }, desc = "prev-empty-line (paragraph)" },
      { [1] = "}",  icon = { icon = licons.next }, mode = { "n", "x" }, desc = "next-empty-line (paragraph)" },

      { [1] = "c", icon = { icon = "󰬳 " }, mode = { "n", "x" }, desc = "change" },
      { [1] = "d", icon = { icon = "󰇾 " }, mode = { "n", "x" }, desc = "delete" }, -- nf-md-eraser
      { [1] = "r", icon = { icon = "󰬳 " }, mode = { "n", "x" }, desc = "replace" }, -- nf-md-file_replace_outline
      { [1] = "y", icon = { icon = "󰆏 " }, mode = { "n", "x" }, desc = "yank" }, -- nf-md-content_copy

      { [1] = "h",       icon = { icon = "󰅁 " }, mode = { "n", "x" }, desc = "left" },
      { [1] = "j",       icon = { icon = "󰅀 " }, mode = { "n", "x" }, desc = "down" },
      { [1] = "k",       icon = { icon = "󰅃 " }, mode = { "n", "x" }, desc = "up" },
      { [1] = "l",       icon = { icon = "󰅂 " }, mode = { "n", "x" }, desc = "right" },
      { [1] = "<Left>",  icon = { icon = "󰅁 " }, mode = { "n", "x" }, desc = "left" },
      { [1] = "<Down>",  icon = { icon = "󰅀 " }, mode = { "n", "x" }, desc = "down" },
      { [1] = "<Up>",    icon = { icon = "󰅃 " }, mode = { "n", "x" }, desc = "up" },
      { [1] = "<Right>", icon = { icon = "󰅂 " }, mode = { "n", "x" }, desc = "right" },

      { [1] = ",",  icon = { icon = licons.prev }, mode = { "n", "x" }, desc = "prev-ftFT" },
      { [1] = ";",  icon = { icon = licons.next }, mode = { "n", "x" }, desc = "next-ftFT" },
      { [1] = "f",  icon = { icon = "󰾹 " }, mode = { "n", "x" }, desc = "move-to-next-char" }, -- nf-md-format_letter_ends_with
      { [1] = "F",  icon = { icon = "󰾹 " }, mode = { "n", "x" }, desc = "move-to-next-char" },
      { [1] = "t",  icon = { icon = "󰾺 " }, mode = { "n", "x" }, desc = "move-before-next-char" }, -- nf-md-format_letter_starts_with
      { [1] = "T",  icon = { icon = "󰾺 " }, mode = { "n", "x" }, desc = "move-before-next-char" },

      { [1] = "e",  icon = { icon = "󰾸 " }, mode = { "n", "x" }, desc = "prev-end-of-word" }, -- nf-md-format_letter_ends_with
      { [1] = "E",  icon = { icon = "󰾸 " }, mode = { "n", "x" }, desc = "prev-end-of-WORD" },
      { [1] = "ge", icon = { icon = "󰾸 " }, mode = { "n", "x" }, desc = "prev-end-of-word" },
      { [1] = "gE", icon = { icon = "󰾸 " }, mode = { "n", "x" }, desc = "prev-end-of-WORD" },
      { [1] = "b",  icon = { icon = "󰾺 " }, mode = { "n", "x" }, desc = "prev-word" }, -- nf-md-format_letter_starts_with
      { [1] = "B",  icon = { icon = "󰾺 " }, mode = { "n", "x" }, desc = "prev-WORD" }, -- nf-md-format_letter_starts_with
      { [1] = "w",  icon = { icon = "󰾺 " }, mode = { "n", "x" }, desc = "next-word" }, -- nf-md-format_letter_starts_with
      { [1] = "W",  icon = { icon = "󰾺 " }, mode = { "n", "x" }, desc = "next-WORD" },
    })

    ---@type wk.IconRule[]
    opts.icons = opts.icons or {}
    opts.icons.rules = vim.list_extend(opts.icons.rules or {}, {
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
    })

    return opts
  end,
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
