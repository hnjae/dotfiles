local package_path = (...)

local M = {}

---@type fun(name: string): string
--- return "" if not found
M.get_color = function(name)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "fg")
end

M.is_root = vim.loop.getuid() == 0
M.is_treesitter = vim.fn.executable("cc") == 1 and not vim.g.vscode
M.is_console = os.getenv("XDG_SESSION_TYPE") == "tty"
M.use_icons = not (os.getenv("XDG_SESSION_TYPE") == "tty" and os.getenv("SSH_TTY") == nil)


M.lsp = {
  is_prettier = require(package_path .. ".lsp.is-prettier"),
  is_deno = require(package_path .. ".lsp.is-deno"),
}


-- for debugging
M.__get_windows = function()
  local window_ids = vim.api.nvim_tabpage_list_wins(0)
  local ret = {}
  for _, winid in pairs(window_ids) do
    local bufid = vim.api.nvim_win_get_buf(winid)
    if bufid == nil then
      goto continue
    end

    if vim.tbl_contains({"notify", "noice"}, vim.api.nvim_buf_get_option(bufid, "filetype")) then
      goto continue
    end

    ret[winid] = {
      bufid = bufid,
      name = vim.api.nvim_buf_get_name(bufid),
      filetype = vim.api.nvim_buf_get_option(bufid, "filetype"),
      buftype = vim.api.nvim_buf_get_option(bufid, "buftype"),
    }
    ::continue::
  end

  vim.notify(vim.inspect(ret))
  return window_ids
end

M.__get_files = function()
  local a =vim.fn.sort(
        vim.fn.globpath(
          vim.fn.stdpath("config"),
          "lua/overseer/template/user/*.lua",
          false,
          true
        )
      )
    require("messages.api").capture_thing(a)
end

M.get_xdg_path = require("utils.get-xdg-path")

M.is_plugin = require("utils.is-plugin")

M.get_browser_cmd = require("utils.get-browser-cmd")

M.get_packages = require("utils.get-packages")
return M
