--[[
DISABLE comment while inserting new line (:help fo-table)

- 그냥 set 으로 설정하면 안먹힘. (2022-04-14)
  - 아마도 override 하는 플러그인이 있을터

- formatoptions 는 쉽게 override 된다.
- defaults: tcqj (2022-05-15)
- vim.opt.formatoptions = "tcqjpn"

Options:
  - t: auto-wrap text using textwidth
  - c: auto-wrap comments using textwidth, inserting the current comment leader automatically
  - q: allow formatting of comments with gq
  - j: remove a comment leader when joining lines.
  - p: Don't break lines at single spaces that follow periods.
  - r: auto-insert the current comment leader after hitting <Enter>
  - n: when formatting text, recognize numbered lists. it wraps after "1."
  - o: automatically insert the current comment leader after hitting 'o'
--]]
local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufNew" }, {
    callback = function(ev)
      -- nofile 등 특수 버퍼 제외
      -- vim.opt_local.buftype:get() 으로 계산하면 안됨. 왜지.. <2025-04-23>
      if vim.api.nvim_get_option_value("buftype", { buf = ev.buf }) ~= "" then
        return
      end

      vim.opt_local.formatoptions:remove("r")
      vim.opt_local.formatoptions:remove("o")
      vim.opt_local.formatoptions:remove("t")
      vim.opt_local.formatoptions:remove("c")
    end,
  })
end

return M
