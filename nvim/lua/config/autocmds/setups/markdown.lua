local M = {}

local last_modified = function()
  if vim.opt_local.modified:get() then
    local save_cur = vim.fn.getpos(".")

    vim.cmd([[
      let n = min([10, line("$")])
      keepjumps exe '1,' . n . 's#^\(.\{,10}lastmod\s*: \).*#\1' .
                  \ strftime('%Y-%m-%dT%H:%M:%S%z') . '#e'
    ]])
    vim.fn.histdel("search", -1)
    vim.fn.setpos(".", save_cur)
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
    "title   : " .. filename,
    "date    : " .. dateiso,
    "lastmod : " .. dateiso,
    "isCJKLanguage : true",
    "draft   : true",
    "---",
    "",
    ":toc:",
    "",
    "## " .. "h2",
  }
  -- print(vim.inspect(template))
  vim.fn.call(vim.fn.setline, { 1, template })

  -- TODO: change cursor using neovim's api <2023-08-03>
  vim.fn.execute("normal! G")
  vim.fn.execute("normal! $")
end

function M.setup()
  local asciidoc_auto_id = vim.api.nvim_create_augroup("asciidoc-auto", {})
  vim.api.nvim_create_autocmd({
    "BufRead",
    "BufNewFile",
  }, {
    group = asciidoc_auto_id,
    pattern = { "*.md" },
    callback = function()
      new_template()
    end,
  })
  vim.api.nvim_create_autocmd({
    "BufWritePre",
  }, {
    group = asciidoc_auto_id,
    pattern = { "*.md" },
    callback = last_modified,
  })
end

return M
