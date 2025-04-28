local M = {}

local update_lastmod = function()
  if vim.opt_local.modified:get() then
    local save_cur = vim.fn.getpos(".")

    local original_undolevels = vim.opt_local.undolevels:get()

    -- Temporarily disable undo for this buffer
    vim.opt_local.undolevels = -1

    vim.cmd(string.format(
      [[silent! keepjumps %d,%ds#^\(.\{,10}lastmod\s*: \).*#\1%s#e]],
      1, -- Start line
      math.min(10, vim.fn.line("$")), -- End line
      vim.fn.strftime("%Y-%m-%dT%H:%M:%S%z") -- Replacement string
    ))

    vim.fn.histdel("search", -1)
    vim.fn.setpos(".", save_cur)

    -- Restore the original undo levels
    vim.opt_local.undolevels = original_undolevels
  end
end

local new_template = function()
  if vim.fn.col("$") > 1 or vim.fn.line("$") > 1 then
    return
  end

  local filename = vim.fn.expand("%:t")
  local ext_start, _ = filename:find(vim.fn.expand("%:e"))
  filename = filename:sub(1, ext_start - 2)

  local dateiso = vim.fn.strftime("%Y-%m-%dT%H:%M:%S%z")
  local template = {
    "---",
    "date: " .. dateiso,
    "lastmod: " .. dateiso,
    "---",
    "",
  }
  -- print(vim.inspect(template))
  vim.fn.call(vim.fn.setline, { 1, template })

  -- TODO: change cursor using neovim's api <2023-08-03>
  vim.fn.execute("normal! G")
  vim.fn.execute("normal! $")
end

function M.setup()
  local markdown_auto_id = vim.api.nvim_create_augroup("markdown-template", {})
  vim.api.nvim_create_autocmd({
    "BufRead",
    "BufNewFile",
  }, {
    group = markdown_auto_id,
    pattern = { "*.md" },
    callback = function(ev)
      if string.find(ev.match, "/obsidian/") ~= nil then
        return
      end

      new_template()
    end,
  })

  vim.api.nvim_create_autocmd({
    "BufWritePre",
  }, {
    group = markdown_auto_id,
    pattern = { "*.md" },
    callback = update_lastmod,
  })
end

return M
