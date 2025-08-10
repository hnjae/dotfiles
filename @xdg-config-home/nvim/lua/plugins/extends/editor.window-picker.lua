---@description: return true when the window should be filtered
local filter_win = function(window_id, filters)
  local bufnr = vim.api.nvim_win_get_buf(window_id)
  local win_bo = vim.bo[bufnr]

  -- Check filetype against filter
  if
    filters.bo
    and filters.bo.filetype
    and vim.tbl_contains(filters.bo.filetype, win_bo.filetype)
  then
    return true
  end

  -- Check buftype against filter
  if filters.bo and filters.bo.buftype and vim.tbl_contains(filters.bo.buftype, win_bo.buftype) then
    return true
  end

  -- bufferline 등 제거
  if win_bo.buftype == "nofile" and win_bo.filetype == "" then
    return true
  end

  if not filters.include_current_win and window_id == vim.api.nvim_get_current_win() then
    return true
  end

  -- if win_bo.filetype == "" then
  --   -- vim.notify(vim.inspect(win_bo.buftype))
  --   -- vim.notify(vim.inspect(win_bo.filetype))
  --   local bufnr = vim.api.nvim_win_get_buf(window_id)
  --   vim.notify(vim.inspect(vim.fn.getbufinfo(bufnr)))
  -- end

  return false
end

---@type LazySpec
return {
  [1] = "s1n7ax/nvim-window-picker",
  lazy = true,
  cond = not vim.g.vscode,
  version = "2.*",
  main = "window-picker",
  opts = {
    show_prompt = false,
    hint = "floating-big-letter",
    -- hint = "statusline-winbar",
    selection_chars = "esntiroahduflpy",
    filter_func = function(window_ids, filters)
      local filtered_window_ids = {}
      for _, window_id in ipairs(window_ids) do
        if not filter_win(window_id, filters) then
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
          "snacks_notif",
          "notify",
          "noice",
          "lazy",
          "minimap",
          "sagafinder",
          "saga_codeaction",
          "fidget",
          "snacks_layout_box",
        },
        buftype = {
          "picker",
          "prompt",
          -- "acwrite", -- e.g. oil
        },
      },
    },
  },
  keys = {
    {
      [1] = "<Leader>k",
      [2] = function()
        local picked_window_id = require("window-picker").pick_window()
        if picked_window_id == nil then
          vim.notify("No window picked", vim.log.levels.INFO, {
            title = "Window Picker",
          })
          return
        end

        vim.api.nvim_set_current_win(picked_window_id)
      end,
      desc = "window-picker",
    },
    {
      [1] = "<F3>",
      [2] = "<Leader>k",
      mode = { "n", "i" },
      remap = true,
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
