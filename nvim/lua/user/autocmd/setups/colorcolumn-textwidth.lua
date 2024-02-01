local M = {}

-- NOTE: MAX_COLORCOLUMN 이 커지면 vim이 느려짐. <2023-12-11>
local MAX_COLORCOLUMN = 300

local set_colorcolumn = function()
  local textwidth = vim.opt_local.textwidth:get()
  if not textwidth or textwidth < 1 or (textwidth + 1) > MAX_COLORCOLUMN then
    return
  end
  -- NOTE: range에는 starts, end 전부 포함됨 <2023-12-11>
  vim.opt_local.colorcolumn =
    vim.fn.join(vim.fn.range(textwidth + 1, MAX_COLORCOLUMN), ",")
end

M.setup = function()
  local au_id = vim.api.nvim_create_augroup("colorcolumn-textwidth", {})

  vim.api.nvim_create_autocmd(
    { "BufReadPost" },
    { group = au_id, callback = set_colorcolumn }
  )
  vim.api.nvim_create_autocmd(
    { "BufNewFile" },
    { group = au_id, callback = set_colorcolumn }
  )
  vim.api.nvim_create_autocmd(
    { "OptionSet" },
    { pattern = { "textwidth" }, group = au_id, callback = set_colorcolumn }
  )
end

return M
