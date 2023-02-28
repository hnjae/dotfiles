local M = {}

local fcitx_cmd = "fcitx5-remote"

local function _Fcitx2latin()
  if tonumber(vim.fn.system(fcitx_cmd)) ~= 2 then
    return
  end

  vim.b._fcitx_non_latin = true
  -- os.execute(fcitx_cmd .. " -c")
  io.popen(fcitx_cmd .. " -c")
end

local function _Fcitx2NonLatin()
  if vim.b._fcitx_non_latin == nil or not vim.b._fcitx_non_latin then
    return
  end

  -- Needs sleep to prevent fcitx5-hangul's issue in text-input-v3
  io.popen("sleep 0.13 && " .. fcitx_cmd .. " -o")
  vim.b._fcitx_non_latin = false
end

M.setup = function()
  if not vim.fn.has("linux")
      or os.getenv("SSH_TTY") ~= nil
      or os.getenv("DISPLAY") == nil
      or not vim.fn.executable("fcitx5-remote")
  then
    return
  end

  local au_id = vim.api.nvim_create_augroup("fcitx", {})
  vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    group = au_id,
    desc = "change ime if needed",
    callback = _Fcitx2NonLatin,
  })
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    group = au_id,
    desc = "change ime to latin",
    callback = _Fcitx2latin,
  })
end
return M
