local M = {}

-- NOTE: MAX_COLORCOLUMN 이 커지면 vim이 느려짐. <2023-12-11>
local MAX_COLORCOLUMN = 300

--[[

Examples of event:

```lua
{
  buf = 1,
  event = "BufWinEnter",
  file = "/home/hnjae/Projects/dotfiles/nvim/lua/config/autocmds/setups/colorcolumn-textwidth.lua",
  group = 22,
  id = 96,
  match = "/home/hnjae/Projects/dotfiles/nvim/lua/config/autocmds/setups/colorcolumn-textwidth.lua"
}
```

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

---@param event vim.api.keyset.create_autocmd.callback_args
local set_colorcolumn = function(event)
  if not vim.api.nvim_get_option_value("buflisted", { buf = event.buf }) then
    return
  end

  if vim.api.nvim_get_option_value("filetype", { buf = event.buf }) == "gitcommit" then
    return
  end

  local textwidth = vim.api.nvim_get_option_value("textwidth", { buf = event.buf })
  local winid = vim.fn.bufwinid(event.buf)

  if winid < 0 then
    return
  end

  if
    not textwidth
    or textwidth < 1
    or (textwidth + 1) > MAX_COLORCOLUMN
    or vim.fn.winwidth(winid)
        - vim.api.nvim_get_option_value("numberwidth", { win = winid })
        - 2
      < textwidth -- 2 = signcolumn + foldcolumn
  then
    vim.opt_local.colorcolumn = ""

    return
  end

  -- NOTE: range에는 starts, end 전부 포함됨 <2023-12-11>
  vim.opt_local.colorcolumn =
    vim.fn.join(vim.fn.range(textwidth + 1, math.min(MAX_COLORCOLUMN, vim.fn.winwidth(winid))), ",")
end

M.setup = function()
  if vim.g.vscode then
    return
  end

  local au_id = vim.api.nvim_create_augroup("colorcolumn-textwidth", {})

  vim.api.nvim_create_autocmd(
    -- "BufReadPost" : before modeline
    -- { "BufReadPost", "BufNewFile" },
    -- { "BufWinEnter" },
    { "WinNew", "VimEnter" }, -- -- NOTE: WinNew does not includes first window <2025-04-22>
    { group = au_id, callback = set_colorcolumn }
  )

  vim.api.nvim_create_autocmd(
    { "OptionSet" },
    { pattern = { "textwidth" }, group = au_id, callback = set_colorcolumn }
  )
  vim.api.nvim_create_autocmd({ "WinResized" }, { group = au_id, callback = set_colorcolumn })
end

return M
