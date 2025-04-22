--[[
Examples of event:

```lua
{
  buf = 1,
  event = "WinNew",
  file = "/home/hnjae/Projects/dotfiles/nvim/lua/config/autocmds/setups/colorcolumn-textwidth.lua",
  group = 22,
  id = 96,
  match = "/home/hnjae/Projects/dotfiles/nvim/lua/config/autocmds/setups/colorcolumn-textwidth.lua"
}
```

```lua
{
  buf = 1,
  event = "VimEnter",
  file = "/home/hnjae/Projects/dotfiles/nvim/lua/config/autocmds/setups/colorcolumn-textwidth.lua",
  group = 22,
  id = 96,
  match = "/home/hnjae/Projects/dotfiles/nvim/lua/config/autocmds/setups/colorcolumn-textwidth.lua"
}
```

```lua
{
  buf = 1,
  event = "WinResized",
  file = "1000",
  group = 22,
  id = 98,
  match = "1000"
}
``

```lua
{
  buf = 0,
  event = "OptionSet",
  file = "",
  group = 22,
  id = 97,
  match = "textwidth"
}
```
]]

local M = {}

local get = vim.api.nvim_get_option_value

---@param winid number
---@param bufid number
local win_set_colorcolumn = function(winid, bufid)
  if winid < 0 then
    return
  end

  local bufopts = { buf = bufid, scope = "local" }

  if not get("buflisted", bufopts) then
    return
  end

  if get("filetype", bufopts) == "gitcommit" then
    return
  end

  local winopts = { win = winid, scope = "local" }
  local textwidth = get("textwidth", bufopts)

  -- local sidecolumnwidth = (get("signcolumn", winopts) ~= "no" and 2 or 0)
  --   + (get("foldcolumn", winopts) ~= "0" and 1 or 0)
  --   + math.max(
  --     (get("number", winopts) and get("numberwidth", winopts) or 0),
  --     string.len(tostring(vim.api.nvim_buf_line_count(bufid))) + 1
  --     -- (get("relativenumber", winopts) and 2 or 0),
  --   )

  local sidecolumnwidth = 8
  local winwidth = vim.fn.winwidth(winid)
  local visualwidth = winwidth - sidecolumnwidth

  if textwidth < 1 or visualwidth < textwidth then
    vim.api.nvim_set_option_value("colorcolumn", "", winopts)

    return
  end

  -- NOTE: 여기서 visualwidth 이 커지면 vim이 느려짐. <2023-12-11>
  vim.api.nvim_set_option_value(
    "colorcolumn",
    vim.fn.join(vim.fn.range(textwidth + 1, winwidth), ","),
    { scope = "local", win = winid }
  )
end

M.setup = function()
  if vim.g.vscode then
    return
  end

  local au_id = vim.api.nvim_create_augroup("colorcolumn-textwidth", {})

  -- vim.api.nvim_create_autocmd(
  --   -- NOTE: `WinNew` 나 `WinResized` 이벤트만을 사용하면, 첫번째 윈도우에 대해서 colorcolumn 을 설정하지 못한다. <2025-04-22>
  --   -- NOTE: WinResized 로 WinNew 를 커버가능한 듯. <2025-04-22>
  --   { "VimEnter" },
  --   {
  --     group = au_id,
  --     callback = function(ev)
  --       local winid = vim.fn.bufwinid(ev.buf)
  --       win_set_colorcolumn(winid, ev.buf)
  --     end,
  --   }
  -- )

  -- 같은 윈도우에서 버퍼가 바뀌는 경우를 위해 `BufWinEnter` 사용.
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = au_id,
    callback = function(ev)
      local winid = vim.fn.bufwinid(ev.buf)
      win_set_colorcolumn(winid, ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd({
    "WinResized",
  }, {
    group = au_id,
    callback = function()
      -- NOTE: WinResized 이벤트는 Size 가 변한 모든 윈도우에 대해서 발생하는게 아니라, 포커스된 윈도우에 대해서만 발생한다. <2025-04-22>

      -- 현재 윈도우 뿐만 아니라, 영향 받은 다른 모든 윈도우에 대해서 colorcolumn 을 설정.
      for _, winid in ipairs(vim.v.event.windows) do
        win_set_colorcolumn(winid, vim.api.nvim_win_get_buf(winid))
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "OptionSet" }, {
    pattern = { "textwidth" },
    group = au_id,
    callback = function()
      local bufid = vim.fn.bufnr()
      for _, winid in ipairs(vim.fn.win_findbuf(bufid)) do
        win_set_colorcolumn(winid, bufid)
      end
    end,
  })
end

return M
