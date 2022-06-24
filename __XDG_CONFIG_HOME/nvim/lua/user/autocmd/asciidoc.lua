local M = {}

local last_modified = function()
  -- if vim.opt.filetype:get() ~= "vimwiki" then
  --   return
  -- end

  if vim.opt.modified:get() then
    local save_cur = vim.fn.getpos('.')
    -- local n = math.min(6, vim.fn.line("$"))
    vim.cmd([[
      let n = min([10, line("$")])
      keepjumps exe '1,' . n . 's#^\(.\{,10}lastmod\s*: \).*#\1' .
                  \ strftime('%Y-%m-%dT%H:%M:%S%z') . '#e'
    ]])
    -- local keepjumps_exe = "keepjumps exe " .. "'1,'" .. n .. "'s#^(.{,4}updated\\s*: ).*#\1'" .. vim.fn.strftime('%Y-%m-%dT%H:%M:%S%z') .. "'#e'"
    -- vim.fn.execute(keepjumps_exe)
    vim.fn.histdel("search", -1)
    vim.fn.setpos(".", save_cur)
    -- vim.fn.keepjumps(exe, keepjumps_exe)

  end
end

local new_template = function()
  -- if vim.opt.filetype:get() ~= "vimwiki" then
  --   return
  -- end
  --
  -- local is_wiki = false
  -- for _, wiki in pairs(vim.g.vimwiki_list) do
  --   if vim.fn.expand(('%:p:h'), false, false) == vim.fn.expand(wiki["path"], false, false) then
  --     is_wiki = true
  --     break
  --   end
  -- end

  -- if not is_wiki or vim.fn.line("$") > 1 then
  --   return
  -- end

  if vim.fn.line("$") > 1 or vim.fn.col("$") > 1 then
    return
  end

  local filename = vim.fn.expand("%:t")
  local ext_start, _ = filename:find(vim.fn.expand("%:e"))
  filename = filename:sub(1, ext_start-2)

  local dateiso = vim.fn.strftime('%Y-%m-%dT%H:%M:%S%z')
  local template = {
    "---",
    "title   : " .. filename,
    "date    : " .. dateiso,
    "lastmod : " .. dateiso,
    "isCJKLanguage : true",
    "---",
    "",
    "= " .. filename,
    -- "Hyunjae Kim <hyunjae.kim@gmx.com>",
    ":toc:",
    "",
    "",
    -- TODO: read author and email from ultisnips <2022-06-15, Hyunjae Kim>
  }
  -- print(vim.inspect(template))
  vim.fn.call(vim.fn.setline, { 1, template })
  vim.fn.execute('normal! G')
  vim.fn.execute('normal! $')
end


function M.setup()
  -- local vimwikiauto = vim.api.nvim_create_augroup("vimwikiauto")
  vim.api.nvim_create_autocmd({
    "BufRead", "BufNewFile"
  }, {
    -- pattern = {"*wiki/*.md"},
    pattern = { "*.adoc" },
    callback = new_template
  })

  vim.api.nvim_create_autocmd({
    "BufWritePre"
  }, {
    -- pattern = {"*wiki/*.md"},
    pattern = { "*.adoc" },
    callback = last_modified
  })
end

return M
