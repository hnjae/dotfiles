local M = {}

local status_wk, wk = pcall(require, "which-key")
local status_tel, telescope = pcall(require, "telescope")
local status_tel_builtin, t_builtin = pcall(require, "telescope.builtin")
local t_ext = telescope.extensions

_TELESCOPE_PREFIX = "<F3>"

if not status_wk or not status_tel or not status_tel_builtin or not _TELESCOPE_PREFIX then
  M.setup = function() end
  return M
end


-- local edit_opt = function(func)
--   -- Select theme based on current tab size
--   -- OR: Change an option when column size chanegd
--   -- nnoremap <Leader>f :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<cr>
--   -- snoremap <Leader>f :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ winblend = 10 }))<cr>
--   local columns = vim.opt.columns:get()
--   if columns < 122 then
--     func({theme="dropdown"})
--   else
--     func()
--   end
-- end

function M.setup()
  wk.register({ [_TELESCOPE_PREFIX] = { name = "+telescope" } })

  -- nnoremap <leader>fb <cmd>Telescope buffers<cr>
  wk.register({
    ["l"] = { t_builtin.current_buffer_fuzzy_find, "line" },
    ["b"] = { t_builtin.buffers, "buffers" },

    ["o"] = { t_builtin.oldfiles, "oldfiles" },
    ["c"] = { t_builtin.commands, "commands" },
    ["t"] = { t_builtin.treesitter, "treesitter" },
    ["f"] = { t_builtin.find_files, "find-files" },
    ["g"] = { t_builtin.grep_string, "grep-string" },
    ["r"] = { t_builtin.registers, "registers" },
    -- TODO: file_browser<2022-06-16, Hyunjae Kim>
    -- TODO: lvie_grep <2022-06-16, Hyunjae Kim>
    -- ["tt"] = { t_builtin.tags, "tags" },
    -- ["?"] = { t_builtin.builtin, "builtin" },
    --
    -- ["l"] = { t_builtin.builtin, "loclist" },
    ["j"] = { t_builtin.builtin, "jumplist" },
    -- TODO: it hide command name <2022-06-16, Hyunjae Kim>
    -- ["a"] = { ":<C-u>Ag", "Ag" },
    -- ["r"] = { ":<C-u>Rg", "Rg" },
    ----
    -- ["b"] = { ":<C-u>Buffers<CR>", "buffer" },
    -- ["l"] = { ":<C-u>BLines<CR>", "buffer-line" },
    -- ["L"] = { ":<C-u>Lines<CR>", "line" },
    -- ["m"] = { ":<C-u>Marks<CR>", "marks" },
    -- ["w"] = { ":<C-u>Windows<CR>", "windows" },
    -- ["s"] = { ":<C-u>Snippets<CR>", "snippets" },
    -- ["p"] = { ":<C-u>Maps<CR>", "maps" },
    -- ["f"] = { ":<C-u>Filetypes<CR>", "filetypes" },
    ["q"] = { t_builtin.quickfix, "quickfix" },
    ["h"] = { name = "+history" },
    -- ["hh"] = { ":<C-u>History<CR>", "history" },
    -- ["h:"] = { ":<C-u>History:<CR>", "history-:" },
    ["hc"] = { t_builtin.command_history, "command" },
    ["hs"] = { t_builtin.search_history, "search" },
    ["hq"] = { t_builtin.quickfixhistory, "quickfixhistory" },
    ["hk"] = { t_builtin.keymaps, "keymaps" },

    ["s"] = { name = "+set" },
    -- ["sr"] = { t_builtin.reloader "reload-lua-module" },
    ["sf"] = { t_builtin.filetypes, "filetypes" },
    ["sh"] = { t_builtin.highlights, "highlights" },
    ["so"] = { t_builtin.vim_options, "vim-options" },
    ---
    ["u"] = { t_ext.ultisnips.ultisnips, "ultisnips" },
    [_TELESCOPE_PREFIX] = { "<cmd>Telescope<CR>", "ultisnips" },
  }, { prefix = _TELESCOPE_PREFIX, mode = "n" }
  )
end

return M
