local M = {}

-- iterate only limited buffer

local ALLOWED_FTS = { help = true, netrw = true }

M.w = function()
  local initial_winnr = vim.fn.winnr()
  local len_winnr = vim.fn.winnr("$")

  local winnr, bufnr, filetype
  for i = 0, (len_winnr - 2) do
    winnr = (initial_winnr + i) % len_winnr + 1
    bufnr = vim.fn.winbufnr(winnr)
    filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

    if vim.fn.buflisted(bufnr) == 1 or ALLOWED_FTS[filetype] then
      vim.cmd(string.format([[exe %d .. "wincmd w"]], winnr))
      return
    end
  end
end

M.p = function()
  local initial_winnr = vim.fn.winnr()
  local len_winnr = vim.fn.winnr("$")

  local winnr, bufnr, filetype
  for i = 2, len_winnr do
    winnr = (initial_winnr - i) % len_winnr + 1
    bufnr = vim.fn.winbufnr(winnr)
    filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

    if vim.fn.buflisted(bufnr) == 1 or ALLOWED_FTS[filetype] then
      vim.cmd(string.format([[exe %d .. "wincmd w"]], winnr))
      return
    end
  end
end

M.setup = function()
  vim.keymap.set({ "n" }, "<C-w><C-w>", M.w)
  vim.keymap.set({ "n" }, "<C-w><C-p>", M.p)
end

return M
