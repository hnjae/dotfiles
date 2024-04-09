local bufname_allowlist = {
  messages = true,
}

local filter_single_win = function(window_id, filters)
  local bufnr = vim.api.nvim_win_get_buf(window_id)
  local win_bo = vim.bo[bufnr]

  if bufname_allowlist[vim.fn.bufname(bufnr)] then
    return true
  end

  -- Check filetype against filter
  if
    filters.bo
    and filters.bo.filetype
    and vim.tbl_contains(filters.bo.filetype, win_bo.filetype)
  then
    return false
  end

  -- Check buftype against filter
  if
    filters.bo
    and filters.bo.buftype
    and vim.tbl_contains(filters.bo.buftype, win_bo.buftype)
  then
    return false
  end

  if win_bo.buftype == "nofile" and win_bo.filetype == "" then
    -- nofile 통째로 filter 하면, 각종 sidebar 류 작동 안함
    return false
  end

  if
    not filters.include_current_win
    and window_id == vim.api.nvim_get_current_win()
  then
    return false
  end

  -- if
  --   win_bo.buftype == "nofile"
  --   and win_bo.filetype ~= ""
  --   and vim.b[bufnr].did_ftplugin ~= nil
  -- then
  --   -- e.g. preview pane of LspSaga's outline
  --   return false
  -- end

  return true
end

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
      for _, window_id in ipairs(window_ids) do
        if filter_single_win(window_id, filters) then
          table.insert(filtered_window_ids, window_id)
        end
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
          -- "acwrite", -- e.g. oil
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
