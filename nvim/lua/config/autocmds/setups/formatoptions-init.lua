local M = {}

M.setup = function()
  --[[
 DISABLE comment while inserting new line (:help fo-table)
 set formatoptions-=r   " Enter
 set formatoptions-=o   " New line created by O
 set formatoptions-=c   " wrap comment using textwidth
-- autocmd FileType * setlocal formatoptions-=r formatoptions-=o
 그냥 set 으로 설정하면 안먹힘. (2022-04-14)
    - 아마도 override 하는 플러그인이 있을터
--]]

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufNew" }, {
    pattern = { "*" },
    callback = function()
      vim.opt_local.formatoptions:remove("r")
      vim.opt_local.formatoptions:remove("o")
    end,
  })

  -- formatoptions 는 쉽게 override 된다.
  -- vim.opt.formatoptions:remove("r")
  -- vim.opt.formatoptions:remove("o")
  -- defaults: tcqj (2022-05-15)
  -- jcroql -- override by something?
  -- vim.opt.formatoptions = "tcqjpn"
  -- t: auto-wrap text using textwidth
  -- c: auto-wrap comments using textwidth, inserting the current comment leader automatically
  -- q: allow formatting of comments with gq
  -- j: remove a comment leader when joining lines.
  --
  -- p: Don't break lines at single spaces that follow periods.
  -- r: auto-insert the current comment leader after hitting <Enter>
  -- n: when formatting text, recognize numbered lists. it wraps after "1."
  --
  -- o: automatically insert the current comment leader after hitting 'o'
end

return M
