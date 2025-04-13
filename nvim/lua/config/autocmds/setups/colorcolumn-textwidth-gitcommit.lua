--[[
  NOTE: 2025-03-02
    별도 colorcolumn 설정을 하는 이유:

    - neogit 에서는 bufnolisted 로 gitcommit 이 열림.
    - gitcommit 은 첫번째 줄에만 별도의 colorcolumn 을 설정하고 싶기 때문.
--]]
local MAX_COLORCOLUMN = 200

local M = {}

M.setup = function()
  if vim.g.vscode then
    return
  end

  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "gitcommit" },
    callback = function()
      local textwidth = vim.opt_local.textwidth:get()

      if not textwidth or textwidth < 1 or (textwidth + 1) > MAX_COLORCOLUMN then
        if vim.opt_local.colorcolumn ~= "" then
          vim.opt_local.colorcolumn = ""
        end

        return
      end

      -- NOTE: range에는 starts, end 전부 포함됨 <2023-12-11>
      local columns = vim.fn.range(textwidth + 1, MAX_COLORCOLUMN)
      table.insert(columns, 51)
      vim.opt_local.colorcolumn = vim.fn.join(columns, ",")
    end,
  })
end
return M
