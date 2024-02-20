---@type LazySpec
return {
  [1] = "s1n7ax/nvim-window-picker",
  event = "VeryLazy",
  version = "2.*",
  main = "window-picker",
  keys = {
    {
      [1] = "<Leader>f",
      [2] = function()
        local picked_window_id = require("window-picker").pick_window()
        if picked_window_id == nil then
          return
        end
        vim.api.nvim_set_current_win(picked_window_id)
      end,
    },
  },
  opts = {
    hint = "floating-big-letter",
    selection_chars = "neitsrhodaylkfv",
    filter_func = function(window_ids, filters)
      local filtered_window_ids = {}
      for _, win_id in ipairs(window_ids) do
        local win_buf = vim.api.nvim_win_get_buf(win_id)
        local win_bo = vim.bo[win_buf]

        -- 이것 때문에 filter_func 별도 작성
        if win_bo.buftype == "nofile" and win_bo.filetype == "" then
          goto continue
        end

        -- Check filetype against filter
        if filters.bo and filters.bo.filetype then
          if vim.tbl_contains(filters.bo.filetype, win_bo.filetype) then
            goto continue
          end
        end

        -- Check buftype against filter
        if filters.bo and filters.bo.buftype then
          if vim.tbl_contains(filters.bo.buftype, win_bo.buftype) then
            goto continue
          end
        end

        -- Include or exclude the current window based on the filter
        if
          not filters.include_current_win
          and win_id == vim.api.nvim_get_current_win()
        then
          goto continue
        end

        table.insert(filtered_window_ids, win_id)
        ::continue::
      end

      return filtered_window_ids
    end,
    filter_rules = {
      autoselect_one = true,
      include_current_win = true,
      bo = {
        filetype = {
          "notify",
          "noice",
          "TelescopePrompt",
          "lazy",
          "minimap",
        },
        buftype = {
          "picker",
          "prompt",
        },
      },
    },
  },
}

-- for debugging
-- filter_func = function(window_ids, filters)
--   require("notify").dismiss()
--   local ret = {}
--   for _, winid in pairs(window_ids) do
--     local bufid = vim.api.nvim_win_get_buf(winid)
--     if bufid == nil then
--       goto continue
--     end
--
--     if vim.api.nvim_buf_get_option(bufid, "filetype") == "noice" then
--       goto continue
--     end
--     if vim.api.nvim_buf_get_option(bufid, "filetype") == "notify" then
--       goto continue
--     end
--     ret[winid] = {
--       bufid = bufid,
--       name = vim.api.nvim_buf_get_name(bufid),
--       filetype = vim.api.nvim_buf_get_option(bufid, "filetype"),
--       buftype = vim.api.nvim_buf_get_option(bufid, "buftype"),
--     }
--     ::continue::
--   end
--
--   vim.notify(vim.inspect(ret))
--   return window_ids
-- end,
