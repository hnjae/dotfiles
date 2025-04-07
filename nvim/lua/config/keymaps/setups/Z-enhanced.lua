local M = {}

local is_normal_buf = function(bufnr)
  if vim.api.nvim_buf_get_option(bufnr, "buftype") == "" then
    return true
  end

  return false
end

local ignore_fts = {
  -- notify = true,
  -- noice = true,
  -- cmp_menu = true,
  -- cmp_docs = true,
}

local zz_enhanced = function(mode)
  local normal_bufnrs = {}
  local abnormal_bufnrs = {}
  local get_winnrs = function()
    return vim.api.nvim_tabpage_list_wins(vim.fn.tabpagenr())
  end

  -- 탭이 하나 있을때, 아래 같은 이슈가 발생가 종종 있음 <2024-07-19>
  -- E5108: Error executing lua [string ":lua"]:1: Invalid tabpage id: 1
  local status, winnrs = pcall(get_winnr)
  if not status then
    if mode == "ZZ" then
      vim.cmd("x")
    elseif mode == "ZQ" then
      vim.cmd("q!")
    end
    return
  end

  -- local winnrs =
  for _, winnr in ipairs(winnrs) do
    -- not floating
    if vim.api.nvim_win_get_config(winnr).zindex then
      goto continue
    end

    local bufnr = vim.api.nvim_win_get_buf(winnr)

    if ignore_fts[vim.api.nvim_buf_get_option(bufnr, "filetype")] then
      goto continue
    end

    if is_normal_buf(bufnr) then
      table.insert(normal_bufnrs, bufnr)
    else
      table.insert(abnormal_bufnrs, bufnr)
    end

    ::continue::
  end

  if is_normal_buf(0) and (#normal_bufnrs == 1) and (#abnormal_bufnrs ~= 0) then
    for _, bufnr in ipairs(abnormal_bufnrs) do
      if vim.api.nvim_buf_get_option(bufnr, "filetype") == "minimap" then
        vim.cmd("MinimapClose")
      else
        vim.api.nvim_buf_delete(bufnr, {})
      end
    end
  end

  -- if vim.api.nvim_buf_get_option(0, "filetype") == "minimap" then
  --   vim.cmd("MinimapClose")
  -- vim.api.nvim_set_current_win(window_id)
  if mode == "ZZ" then
    vim.cmd("x")
  elseif mode == "ZQ" then
    vim.cmd("q!")
  end
end

M.setup = function()
  vim.keymap.set("n", "ZZ", function()
    zz_enhanced("ZZ")
  end, { desc = "ZZ-enhanced" })
  vim.keymap.set("n", "ZQ", function()
    zz_enhanced("ZQ")
  end, { desc = "ZQ-enhanced" })
end

return M
