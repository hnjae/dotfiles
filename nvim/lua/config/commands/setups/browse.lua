-- WIP
-- NOTE: fugitive 에서 GBrowse 가 작동하기 위해서 작성 <2024-03-22>
-- fugitive 는 netrw 기능을 이용해서 GBrowse 를 사용하는데, oil.nvim 에서 netrw
-- 를 오버라이드 하기 때문.

local M = {}

local utils = require("utils")
local get_opener = function()
  if utils.is_root or utils.is_console then
    return nil
  end

  if vim.fn.has("linux") == 1 then
    return "xdg-open"
  end

  if vim.fn.has("mac") == 1 then
    return "open"
  end

  return nil
end

M.setup = function()
  local opener = get_opener()

  vim.api.nvim_create_user_command("Browse", function(opts)
    if not opener then
      local msg = "Not supported in the current environment"
      vim.notify(msg)
    end

    vim.fn.jobstart({ opener, vim.fn.trim(opts.fargs[1]) }, { detach = true })
  end, {
    desc = "Browse",
    nargs = "+",
  })
end

return M
