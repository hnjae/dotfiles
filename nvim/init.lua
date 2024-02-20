-- $XDG_CONFIG_HOME/nvim/init.lua

require("user.builtin").setup()

require("setup-lazy").setup()

require("user.autocmd").setup()
require("setup-semi-plugins").setup()

-- require("event-test").setup()

-- _G.GetCommentstring = function(inp)
--   local inp = "TODO"
--   return string.format(vim.bo.commentstring, inp)
-- end

-- vim.cmd([[
-- " init.vim
-- function! CallLuaGetCommentMarker()
--   return luaeval('GetCommentstring()')
-- endfunction
-- ]])

-- MM = function()
--   local ret = {}
--   for _, winid in pairs(vim.api.nvim_list_wins()) do
--     local bufid = vim.api.nvim_win_get_buf(winid)
--     ret[winid] = {
--       bufid = bufid,
--       name = vim.api.nvim_buf_get_name(bufid),
--       filetype = vim.api.nvim_buf_get_option(bufid, "filetype"),
--       buftype = vim.api.nvim_buf_get_option(bufid, "buftype"),
--     }
--   end
--   -- require("messages.api").capture_thing(vim.inspect(ret))
--   vim.notify(vim.inspect(ret))
--   return vim.inspect(ret)
-- end

-- vim.api.nvim_create_autocmd({ "WinNew", "WinEnter" }, {
--   -- pattern = { "*" },
--   callback = function()
--     MM()
--   end,
-- })
--

-- vim.keymap.set({ "n" }, "ZZ", function()
--   if vim.bo.filetype == "minimap" then
--     -- vim.cmd("MinimapClose")
--     vim.api.nvim_win_close(0, true)
--     -- vim.api.nvim_buf_delete(0, {})
--     return
--   end
--   vim.cmd("x")
-- end, {})
