local icons = require("globals").icons

local licons = {
  prev = "󰶢 ",
  next = "󰔰 ",
  close = "󰅖",
  move_cursor = "󰮴 ", -- nf-md-pan
  method = " ", -- nf-cod-symbol_method
}
---@type LazySpec
return {
  [1] = "which-key.nvim",
  opts_extend = { "spec", "icons.rules" },
  optional = true,

  dependencies = {
    { [1] = "LazyVim", optional = true }, -- to use LazyVim's icons
  },
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
      { [1] = "g[", mode = { "n", "x", "o" }, icon = { icon = licons.prev } }, -- mini.ai
      { [1] = "g]", mode = { "n", "x", "o" }, icon = { icon = licons.next } }, -- mini.ai

      { [1] = "<Leader>-", mode = { "n" }, icon = { icon = " " } },
      { [1] = "<Leader>|", mode = { "n" }, icon = { icon = " " } },

      ----------------------------------------------------------------------------------------------
      -- Add missing icon from neovim
      ----------------------------------------------------------------------------------------------
      { [1] = "<C-w>s",    mode = { "n" }, icon = { icon = " " }, desc = "split-window-horizontally" },
      { [1] = "<C-w>v",    mode = { "n" }, icon = { icon = " " }, desc = "split-window-vertically" },
      { [1] = "<C-w>o",    mode = { "n" }, icon = { icon = " " }, desc = "close-all-other-windows" },
      { [1] = "<C-w>q",    mode = { "n" }, icon = { icon = licons.close }, desc = "quit-a-window" },

      { [1] = "<C-w><",    mode = { "n" }, icon = { icon = "󰲏 " }, desc = "decrease-width" },
      { [1] = "<C-w>>",    mode = { "n" }, icon = { icon = "󰲏 " }, desc = "increase-width" },
      { [1] = "<C-w>-",    mode = { "n" }, icon = { icon = "󰲏 " }, desc = "decrease-height" },
      { [1] = "<C-w>+",    mode = { "n" }, icon = { icon = "󰲏 " }, desc = "increase-height" },
      { [1] = "<C-w>=",    mode = { "n" }, icon = { icon = "󰲏 " }, desc = "equally-high-and-wide" },
      { [1] = "<C-w>_",    mode = { "n" }, icon = { icon = "󰲏 " }, desc = "max-out-the-height" },
      { [1] = "<C-w>|",    mode = { "n" }, icon = { icon = "󰲏 " }, desc = "max-out-the-width" },

      { [1] = "<C-w>x",    mode = { "n" }, icon = { icon = "󰓡 " }, desc = "swap-current-with-next" },

      { [1] = "<C-w>H",    mode = { "n" }, icon = { icon = "󰖲 " }, desc = "move-window-to-far-left" },
      { [1] = "<C-w>J",    mode = { "n" }, icon = { icon = "󰖲 " }, desc = "move-window-to-far-bottom" },
      { [1] = "<C-w>K",    mode = { "n" }, icon = { icon = "󰖲 " }, desc = "move-window-to-far-top" },
      { [1] = "<C-w>L",    mode = { "n" }, icon = { icon = "󰖲 " }, desc = "move-window-to-far-right" }, -- alts: nf-md-pan

      { [1] = "<C-w>w",       mode = { "n" }, icon = { icon = "󰆾 " }, desc = "switch-windows" },
      { [1] = "<C-w>h",       mode = { "n" }, icon = { icon = "󰆾 " }, desc = "go-to-the-left-window" }, -- 󰆾
      { [1] = "<C-w>j",       mode = { "n" }, icon = { icon = "󰆾 " }, desc = "go-to-the-down-window" },
      { [1] = "<C-w>k",       mode = { "n" }, icon = { icon = "󰆾 " }, desc = "go-to-the-up-window" },
      { [1] = "<C-w>l",       mode = { "n" }, icon = { icon = "󰆾 " }, desc = "go-to-the-right-window" },
      { [1] = "<C-w><Left>",  mode = { "n" }, icon = { icon = "󰆾 " }, desc = "go-to-the-left-window" },
      { [1] = "<C-w><Down>",  mode = { "n" }, icon = { icon = "󰆾 " }, desc = "go-to-the-down-window" },
      { [1] = "<C-w><Up>",    mode = { "n" }, icon = { icon = "󰆾 " }, desc = "go-to-the-up-window" },
      { [1] = "<C-w><Right>", mode = { "n" }, icon = { icon = "󰆾 " }, desc = "go-to-the-right-window" },


      -- change buffer
      { [1] = "[<Space>", icon = { icon = " ", color = "green" }, desc = "insert-empty-line-above-cursor" }, -- nf-cod-insert
      { [1] = "]<Space>", icon = { icon = " ", color = "green" }, desc = "insert-empty-line-below-cursor" }, -- nf-cod-insert
      { [1] = "<", icon = { icon = "󰉵 ", color = "green" }, desc = "+indent-left" },
      { [1] = ">", icon = { icon = "󰉶 ", color = "green" }, desc = "+indent-right" },  -- nf-md-format_indent_increase
      { [1] = "<", icon = { icon = "󰉵 ", color = "green" }, mode = { "x" }, desc = "indent-left" },
      { [1] = ">", icon = { icon = "󰉶 ", color = "green" }, mode = { "x" }, desc = "indent-right" },  -- nf-md-format_indent_increase

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


      -- motion
      { [1] = "c", icon = { icon = "󰬳 " }, mode = { "n", "x" }, desc = "change" },
      { [1] = "d", icon = { icon = "󰇾 " }, mode = { "n", "x" }, desc = "delete" }, -- nf-md-eraser
      { [1] = "r", icon = { icon = "󰬳 " }, mode = { "n", "x" }, desc = "replace" }, -- nf-md-file_replace_outline
      { [1] = "y", icon = { icon = "󰆏 " }, mode = { "n", "x" }, desc = "yank" }, -- nf-md-content_copy
      { [1] = "!", icon = { icon = "󰏋 " }, mode = { "n", "x" }, desc = "run-program" },  -- nf-md-open_in_app

      { [1] = "v", icon = { icon = "󰩬 " }, mode = { "n", "x" }, desc = "visual" },  -- nf-md-selection_drag
      { [1] = "V", icon = { icon = "󰩬 " }, mode = { "n", "x" }, desc = "visual-line" },  -- nf-md-selection_drag

      { [1] = "=", icon = { icon = "= " }, mode = { "n" }, desc = "+equalprg" },
      -- { [1] = "a", icon = { icon = "⟷ " }, mode = { "x" }, desc = "+around" },
      -- { [1] = "i", icon = { icon = "󰡎 " }, mode = { "x" }, desc = "+inside" },

      -- motion, operator-pending
      { [1] = "[",  icon = { icon = licons.prev }, mode = { "n", "x", "o" }, desc = "+prev" },
      { [1] = "]",  icon = { icon = licons.next }, mode = { "n", "x", "o" }, desc = "+next" },
      { [1] = "g",  icon = { icon = "󱁤 "}, mode = { "n", "x", "o" }, desc = "+extra-cmds" },
      { [1] = "z",  icon = { icon = "󱁤 "}, mode = { "n" }, desc = "+extra-cmds" },

      { [1] = "%",  icon = { icon = "󰅪 " }, mode = { "n", "x", "o" }, desc = "forward-matching" }, -- nf-md-code_brackets
      { [1] = "g%", icon = { icon = "󰅪 " }, mode = { "n", "x", "o" }, desc = "backwords-matching" }, -- nf-md-code_brackets

      { [1] = "[s", icon = { icon = "󰓆 " }, mode = { "n", "x", "o" }, desc = "prev-misspelled" }, -- nf-md-spellcheck
      { [1] = "]s", icon = { icon = "󰓆 " }, mode = { "n", "x", "o" }, desc = "next-misspelled" }, -- nf-md-spellcheck
      { [1] = "zg", icon = { icon = "󰓆 " }, mode = { "n" },           desc = "add-word-to-spell-list" }, -- nf-md-spellcheck
      { [1] = "zw", icon = { icon = "󰓆 " }, mode = { "n" },           desc = "make-word-as-bad/missspelling" }, -- nf-md-spellcheck
      { [1] = "z=", icon = { icon = "󰓆 " }, mode = { "n" },           desc = "spelling-suggestions" }, -- nf-md-spellcheck

      { [1] = "[m", icon = { icon = licons.method }, mode = { "n", "x", "o" }, desc = "prev-method" },
      { [1] = "[M", icon = { icon = licons.method }, mode = { "n", "x", "o" }, desc = "prev-method-end" },
      { [1] = "]m", icon = { icon = licons.method }, mode = { "n", "x", "o" }, desc = "prev-method" },
      { [1] = "]M", icon = { icon = licons.method }, mode = { "n", "x", "o" }, desc = "prev-method-end" },

      { [1] = "gg", icon = { icon = "󰞕 " }, mode = { "n", "x", "o" }, desc = "goto-first-line" }, -- nf-md-arrow_collapse_up
      { [1] = "G",  icon = { icon = "󰞒 " }, mode = { "n", "x", "o" }, desc = "last-line" }, -- nf-md-page_first

      { [1] = "0",      icon = { icon = "󰘀 " }, mode = { "n", "x", "o" }, desc = "start-of-line" }, -- nf-md-page_first
      { [1] = "<Home>", icon = { icon = "󰘀 " }, mode = { "n", "x", "o" }, desc = "start-of-line" }, -- nf-md-page_first
      { [1] = "$",      icon = { icon = "󰘁 " }, mode = { "n", "x", "o" }, desc = "end-of-line" }, -- nf-md-page_last
      { [1] = "<End>",  icon = { icon = "󰘁 " }, mode = { "n", "x", "o" }, desc = "end-of-line" }, -- nf-md-page_last

      { [1] = "^",  icon = { icon = licons.prev }, mode = { "n", "x", "o" }, desc = "first-non-blank-char" },
      { [1] = "g_", icon = { icon = licons.next }, mode = { "n", "x", "o" }, desc = "last-non-blank-char" },
      { [1] = "(",  icon = { icon = licons.prev }, mode = { "n", "x", "o" }, desc = "prev-sentence" },
      { [1] = ")",  icon = { icon = licons.next }, mode = { "n", "x", "o" }, desc = "next-sentence" },
      { [1] = "{",  icon = { icon = licons.prev }, mode = { "n", "x", "o" }, desc = "prev-empty-line (paragraph)" },
      { [1] = "}",  icon = { icon = licons.next }, mode = { "n", "x", "o" }, desc = "next-empty-line (paragraph)" },

      { [1] = "h",       icon = { icon = "󰅁 " }, mode = { "n", "x", "o" }, desc = "left" },
      { [1] = "j",       icon = { icon = "󰅀 " }, mode = { "n", "x", "o" }, desc = "down" },
      { [1] = "k",       icon = { icon = "󰅃 " }, mode = { "n", "x", "o" }, desc = "up" },
      { [1] = "l",       icon = { icon = "󰅂 " }, mode = { "n", "x", "o" }, desc = "right" },
      { [1] = "<Left>",  icon = { icon = "󰅁 " }, mode = { "n", "x", "o" }, desc = "left" },
      { [1] = "<Down>",  icon = { icon = "󰅀 " }, mode = { "n", "x", "o" }, desc = "down" },
      { [1] = "<Up>",    icon = { icon = "󰅃 " }, mode = { "n", "x", "o" }, desc = "up" },
      { [1] = "<Right>", icon = { icon = "󰅂 " }, mode = { "n", "x", "o" }, desc = "right" },

      { [1] = ",",  icon = { icon = licons.prev }, mode = { "n", "x", "o" }, desc = "prev-ftFT" },
      { [1] = ";",  icon = { icon = licons.next }, mode = { "n", "x", "o" }, desc = "next-ftFT" },
      { [1] = "f",  icon = { icon = "󰨿 " }, mode = { "n", "x", "o" }, desc = "move-to-next-char" },
      { [1] = "F",  icon = { icon = "󰨿 " }, mode = { "n", "x", "o" }, desc = "move-to-next-char" },
      { [1] = "t",  icon = { icon = "󰩀 " }, mode = { "n", "x", "o" }, desc = "move-before-next-char" },
      { [1] = "T",  icon = { icon = "󰩀 " }, mode = { "n", "x", "o" }, desc = "move-before-next-char" },

      { [1] = "e",  icon = { icon = "󰨿 " }, mode = { "n", "x", "o" }, desc = "prev-end-of-word" }, -- 󰾸 : nf-md-format_letter_ends_with
      { [1] = "E",  icon = { icon = "󰨿 " }, mode = { "n", "x", "o" }, desc = "prev-end-of-WORD" },
      { [1] = "ge", icon = { icon = "󰨿 " }, mode = { "n", "x", "o" }, desc = "prev-end-of-word" },
      { [1] = "gE", icon = { icon = "󰨿 " }, mode = { "n", "x", "o" }, desc = "prev-end-of-WORD" },
      { [1] = "b",  icon = { icon = "󰩀 " }, mode = { "n", "x", "o" }, desc = "prev-word" }, -- 󰾺 : nf-md-format_letter_starts_with
      { [1] = "B",  icon = { icon = "󰩀 " }, mode = { "n", "x", "o" }, desc = "prev-WORD" },
      { [1] = "w",  icon = { icon = "󰩀 " }, mode = { "n", "x", "o" }, desc = "next-word" },
      { [1] = "W",  icon = { icon = "󰩀 " }, mode = { "n", "x", "o" }, desc = "next-WORD" },

      -- z
      { [1] = "z<CR>", icon = { icon = "󰝕 " }, desc = "top-this-line" },  -- nf-md-format_align_top
      { [1] = "zt",    icon = { icon = "󰝕 " }, desc = "top-this-line" },  -- nf-md-format_align_top
      { [1] = "zb",    icon = { icon = "󰝓 " }, desc = "bottom-this-line" },
      { [1] = "z-",    icon = { icon = "󰝓 " }, desc = "bottom-this-line" },
      { [1] = "zz",    icon = { icon = "󰘢 " }, desc = "center-this-line" }, -- nf-md-format_vertical_align_center
      { [1] = "z.",    icon = { icon = "󰘢 " }, desc = "center-this-line" }, -- nf-md-format_vertical_align_center

      { [1] = "zh",       icon = { icon = "󰘟 " }, desc = "screen-to-left" }, -- nf-md-format_horizontal_align_left
      { [1] = "z<Left>",  icon = { icon = "󰘟 " }, desc = "screen-to-left" }, -- nf-md-format_horizontal_align_left
      { [1] = "zl",       icon = { icon = "󰘠 " }, desc = "screen-to-right" },
      { [1] = "z<Right>", icon = { icon = "󰘠 " }, desc = "screen-to-right" },
      { [1] = "zH",       icon = { icon = "󰘟 " }, desc = "half-screen-to-left" }, -- nf-md-format_horizontal_align_left
      { [1] = "zL",       icon = { icon = "󰘠 " }, desc = "half-screen-to-right" },
      { [1] = "zs",       icon = { icon = "󰘟 " }, desc = "left-this-line" }, -- nf-md-format_horizontal_align_left
      { [1] = "ze",       icon = { icon = "󰘠 " }, desc = "right-this-line" },

      { [1] = "zc",    icon = { icon = "󰡍 " }, desc = "close-fold-under-cursor" },
      { [1] = "zC",    icon = { icon = "󰡍 " }, desc = "close-all-fold-under-cursor" },
      { [1] = "zm",    icon = { icon = "󰡍 " }, desc = "fold-more" },
      { [1] = "zM",    icon = { icon = "󰡍 " }, desc = "close-all-fold" },
      { [1] = "zf",    icon = { icon = "󰡍 " }, mode = {"n", "x" }, desc = "create-fold" },

      { [1] = "zd",    icon = { icon = " " }, desc = "delete-fold-under-cursor" }, -- nf-cod-fold
      { [1] = "zD",    icon = { icon = " " }, desc = "delete-all-folds-under-cursor" }, -- nf-cod-fold
      { [1] = "zE",    icon = { icon = " " }, desc = "delete-all-folds-in-file" }, -- nf-cod-fold
      { [1] = "zx",    icon = { icon = " " }, desc = "update-folds" }, -- nf-cod-fold
      { [1] = "zX",    icon = { icon = " " }, desc = "update-folds" }, -- nf-cod-fold

      { [1] = "zo",    icon = { icon = "󰡏 " }, desc = "open-fold-under-cursor" },
      { [1] = "zO",    icon = { icon = "󰡏 " }, desc = "open-all-folds-under-cursor" },
      { [1] = "zv",    icon = { icon = "󰡏 " }, desc = "show-cursor-line (open-enough-folds)" },
      { [1] = "zr",    icon = { icon = "󰡏 " }, desc = "fold-less" },
      { [1] = "zR",    icon = { icon = "󰡏 " }, desc = "open-all-folds" },
    },

    icons = {
      keys = {
        Up = "▲ ", -- unicode
        Down = "▼ ", -- unicode
        Left = "◀ ", -- unicode
        Right = "▶ ", -- unicode
        BS = "󰭜 ",
      },

      ---@type wk.IconRule[]
      rules = {
        -- add new pattern
        -- { pattern = "prev", icon = "󰄽 ", color = "grey" },
        -- { pattern = "next", icon = "󰄾 ", color = "grey" },
        -- { pattern = "fold", icon = " ", color = "grey" }, -- nf-cod-fold

        ----------------------------------------------------------------------------------------------
        -- override defaults rules
        ----------------------------------------------------------------------------------------------
        -- { pattern = "profiler", icon = "⚡", color = "orange" },
        -- { plugin = "CopilotChat.nvim", icon = " ", color = "orange" },
        -- { pattern = "%f[%a]git", cat = "filetype", name = "git" },
        -- { pattern = "terminal", icon = " ", color = "red" },
        { pattern = "find", icon = icons.search, color = "green" },
        { pattern = "search", icon = icons.search, color = "green" },
        -- { pattern = "test", cat = "filetype", name = "neotest-summary" },
        -- { pattern = "lazy", cat = "filetype", name = "lazy" },
        { pattern = "buffer", icon = "󱇨 ", color = "cyan" },
        { pattern = "file", icon = "󰈤 ", color = "cyan" }, -- nf-md-file_outline
        -- { pattern = "window", icon = " ", color = "blue" },
        -- { pattern = "diagnostic", icon = "󱖫 ", color = "green" },
        { pattern = "format", icon = icons.sort, color = "cyan" },
        { pattern = "debug", icon = " ", color = "red" }, -- nf-cod-debug
        { pattern = "code", icon = "󰅴 ", color = "orange" }, -- nf-md-code_tags
        -- { pattern = "notif", icon = "󰵅 ", color = "blue" },
        { pattern = "toggle", icon = icons.toggle, color = "yellow" }, -- nf-md-toggle_switch_outline
        -- { pattern = "session", icon = " ", color = "azure" },
        -- { pattern = "exit", icon = "󰈆 ", color = "red" },
        -- { pattern = "quit", icon = "󰈆 ", color = "red" },
        -- { pattern = "tab", icon = "󰓩 ", color = "purple" },
        { pattern = "%f[%a]ai", icon = icons.ai, color = "green" }, -- nf-md-robot_outline
        -- { pattern = "ui", icon = "󰙵 ", color = "cyan" },
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
