---@type LazySpec
return {
  [1] = "Apeiros-46B/qalc.nvim",
  lazy = true,
  enabled = false,
  cond = vim.fn.executable("qalc") == 1,
  opts = {},
  cmd = {
    "Qalc",
    "QalcYank",
    "QalcAttach",
  },
}
-- qalc buffer:

--   [10] = {
--     buflisted = 1,
--     bufloaded = 1,
--     bufname = "",
--     buftype = "",
--     bufwinid = 1000,
--     bufwinnr = 1,
--     filetype = "config",
--     getbufinfo = { {
--         bufnr = 10,
--         changed = 0,
--         changedtick = 2,
--         command = 0,
--         hidden = 0,
--         lastused = 1727152957,
--         linecount = 1,
--         listed = 1,
--         lnum = 1,
--         loaded = 1,
--         name = "",
--         variables = {
--           autopairs_keymaps = { "{", "}", "[", "]", "(", ")", "'", '"' },
--           changedtick = 2,
--           current_syntax = "config",
--           did_ftplugin = 1,
--           did_indent = 1,
--           match_ignorecase = 0,
--           match_words = "\\%(;\\s*\\|^\\s*\\)\\@<=if\\>:\\%(;\\s*\\|^\\s*\\)\\@<=elif\\>:\\%(;\\s*\\|^\\s*\\)\\@<=else\\>:\\%(;\\s*\\|^\\s*\\)\\@<=fi\\>,\\%(;\\s*\\|^\\s*\\)\\@<=\\%(for\\|while\\)\\>:\\%(;\\s*\\|^\\s*\\)\\@<=done\\>,\\%(;\\s*\\|^\\s*\\)\\@<=case\\>:\\%(;\\s*\\|^\\s*\\)\\@<=esac\\>",
--           ["nvim-autopairs"] = 1,
--           undo_ftplugin = "unlet! b:browsefilter | setl com< cms< fo< | unlet! b:match_ignorecase b:match_words",
--           undo_indent = "setl inde< indk< si<"
--         },
--         windows = { 1000 }
--       } }
--   },
