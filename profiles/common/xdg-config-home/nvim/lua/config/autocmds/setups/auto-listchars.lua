local M = {}

local denylist = {
  [""] = true,
  diff = true,
  help = true,
  text = true,
}

-- local default_listchars = "tab:  ,nbsp:+"

------@param winid number
---local win_reset_listchars = function(winid)
---  vim.api.nvim_set_option_value("listchars", default_listchars, { win = winid })
---end

---@param winid number
---@param bufid number
local win_set_listchars = function(winid, bufid)
  if vim.api.nvim_get_option_value("expandtab", { buf = bufid }) then
    vim.api.nvim_set_option_value("listchars", "tab:⭾-,nbsp:+", { win = winid })
  else
    vim.api.nvim_set_option_value("listchars", "tab:  ,lead:_,nbsp:+", { win = winid })
  end
end

local au_id = vim.api.nvim_create_augroup("auto-listchars", {})

M.setup = function()
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = au_id,
    callback = function(ev)
      -- nofile 등 특수 버퍼 제외
      -- vim.opt_local.buftype:get() 으로 계산하면 안됨. 왜지.. <2025-04-23>
      if vim.api.nvim_get_option_value("buftype", { buf = ev.buf }) ~= "" then
        return
      end

      if denylist[vim.api.nvim_get_option_value("filetype", { buf = ev.buf })] then
        -- win_reset_listchars(winid)
        return
      end

      local winid = vim.fn.bufwinid(ev.buf)
      win_set_listchars(winid, ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd({ "OptionSet" }, {
    pattern = { "expandtab" },
    group = au_id,
    callback = function()
      -- NOTE: ev.buf == 0 <v0.11.0; 2025-04-23>

      local bufid = vim.fn.bufnr()
      if vim.api.nvim_get_option_value("buftype", { buf = bufid }) ~= "" then
        return
      end

      if denylist[vim.api.nvim_get_option_value("filetype", { buf = bufid })] then
        -- for _, winid in ipairs(vim.fn.win_findbuf(bufid)) do
        --   win_reset_listchars(winid)
        -- end
        return
      end

      for _, winid in ipairs(vim.fn.win_findbuf(bufid)) do
        win_set_listchars(winid, bufid)
      end
    end,
  })
end

return M
