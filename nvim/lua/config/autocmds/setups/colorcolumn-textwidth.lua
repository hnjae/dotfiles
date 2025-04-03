local M = {}

-- NOTE: MAX_COLORCOLUMN 이 커지면 vim이 느려짐. <2023-12-11>
local MAX_COLORCOLUMN = 300

local set_colorcolumn = function(obj)
  if not vim.bo[obj.buf].buflisted then
    return
  end

  -- skip gitcommit filetype
  if vim.opt_local.filetype:get() == "gitcommit" then
    return
  end

  local textwidth = vim.opt_local.textwidth:get()
  if not textwidth or textwidth < 1 or (textwidth + 1) > MAX_COLORCOLUMN then
    if vim.opt_local.colorcolumn ~= "" then
      vim.opt_local.colorcolumn = ""
    end

    return
  end

  -- NOTE: range에는 starts, end 전부 포함됨 <2023-12-11>
  vim.opt_local.colorcolumn =
    vim.fn.join(vim.fn.range(textwidth + 1, MAX_COLORCOLUMN), ",")
end

M.setup = function()
  if vim.g.vscode then
    return
  end

  local au_id = vim.api.nvim_create_augroup("colorcolumn-textwidth", {})

  vim.api.nvim_create_autocmd(
    -- "BufReadPost" : before modeline
    -- { "BufReadPost", "BufNewFile" },
    { "BufWinEnter" },
    { group = au_id, callback = set_colorcolumn }
  )
  vim.api.nvim_create_autocmd(
    { "OptionSet" },
    { pattern = { "textwidth" }, group = au_id, callback = set_colorcolumn }
  )
end

return M
