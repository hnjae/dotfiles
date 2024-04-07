local bufname_allowlist = {
  messages = true,
}

-- vim.api.nvim_set_keymap()
---@type LazySpec
return {
  [1] = "s1n7ax/nvim-window-picker",
  lazy = true,
  -- event = "VeryLazy",
  version = "2.*",
  main = "window-picker",
  opts = {
    show_prompt = false,
    hint = "floating-big-letter",
    -- hint = "statusline-winbar",
    selection_chars = "neitsrhodaylkfv",
    -- picker_config = {
    --   floating_big_letter = {
    --     font = "ansi-shadow", -- ansi-shadow |
    --   },
    -- },
    filter_func = function(window_ids, filters)
      local filtered_window_ids = {}
      for _, win_id in ipairs(window_ids) do
        local bufnr = vim.api.nvim_win_get_buf(win_id)
        local win_bo = vim.bo[bufnr]

        if bufname_allowlist[vim.fn.bufname(bufnr)] then
          table.insert(filtered_window_ids, win_id)
          ::continue::
        end

        if win_bo.buftype == "nofile" and win_bo.filetype == "" then
          -- nofile 통째로 filter 하면, 각종 sidebar 류 작동 안함
          goto continue
        end

        if
          win_bo.buftype == "nofile"
          and win_bo.filetype ~= ""
          and vim.b[bufnr].did_ftplugin ~= nil
        then
          -- e.g. preview pane of LspSaga's outline
          goto continue
        end

        if filters.bo then
          -- Check filetype against filter
          if
            filters.bo.filetype
            and vim.tbl_contains(filters.bo.filetype, win_bo.filetype)
          then
            goto continue
          end

          -- Check buftype against filter
          if
            filters.bo.buftype
            and vim.tbl_contains(filters.bo.buftype, win_bo.buftype)
          then
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
          "sagafinder",
          "saga_codeaction",
        },
        buftype = {
          "picker",
          "prompt",
          "acwrite",
        },
      },
    },
    -- highlights = {
    --   enabled = true,
    --   statusline = {
    --     focused = {
    --       fg = "#ededed",
    --       bg = "#e35e4f",
    --       bold = true,
    --     },
    --     unfocused = {
    --       fg = "#ededed",
    --       bg = "#44cc41",
    --       bold = true,
    --     },
    --   },
    --   winbar = {
    --     focused = {
    --       fg = "#ededed",
    --       bg = "#e35e4f",
    --       bold = true,
    --     },
    --     unfocused = {
    --       fg = "#ededed",
    --       bg = "#44cc41",
    --       bold = true,
    --     },
    --   },
    -- },
  },
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
      desc = "window-picker",
    },
  },
  config = function(plugin, opts)
    -- {
    --   "WindowPickerStatusLine",
    --   "WindowPickerStatusLineNC",
    --     "WindowPickerWinBar",
    --     "WindowPickerWinBarNC"
    -- }
    require(plugin.main).setup(opts)
  end,
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
