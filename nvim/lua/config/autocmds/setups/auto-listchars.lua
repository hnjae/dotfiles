local M = {}

local denylist = {
  diff = true,
  help = true,
}

---@param winid number
---@param bufid number
local win_set_listchars = function(winid, bufid)
  if vim.api.nvim_get_option_value("expandtab", { buf = bufid }) then
    vim.api.nvim_set_option_value("listchars", "tab:>-,nbsp:+", { win = winid })
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
        return
      end

      win_set_listchars(vim.fn.bufwinid(ev.buf), ev.buf)
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
        return
      end

      for _, winid in ipairs(vim.fn.win_findbuf(bufid)) do
        win_set_listchars(winid, bufid)
      end
    end,
  })
end

return M
