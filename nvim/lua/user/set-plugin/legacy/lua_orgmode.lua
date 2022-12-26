local status_ok, orgmode = pcall(require, "orgmode")
-- local status_treesitter, treesitter_configs = pcall(require, "nvim-treesitter.configs")

if status_ok  then
  -- vim.cmd([[TSUpdate org]])

  -- require('orgmode').setup({
  -- org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  -- org_default_notes_file = '~/Dropbox/org/refile.org',
  -- })
  -- orgmode.setup({
  --   org_agenda_files = { '~/Sync/Library/org/*' },
  --   org_default_notes_file = '~/Sync/Library/org/refile.org',
  -- })

  -- TODO: not working <2022-05-13, Hyunjae Kim> --
  -- local status_wk, wk = pcall("which-key")
  -- if status_wk then
  -- wk.register({
  --   ["a"] = "open-agenda-prompt",
  --   ["c"] = "open-capture-prompt",
  -- }, {prefix = "<Leader>o"}
  -- )
  -- wk.register({
  --   ["<Leader>oa"] = {name = "open-agenda-prompt"},
  --   -- ["c"] = "open-capture-prompt",
  -- })
  -- end
  local last_modified = function()
    if vim.opt.filetype:get() ~= "vimwiki" then
      return
    end

    if vim.opt.modified:get() then
      vim.cmd([[
        let save_cursor = getpos(".")
        let n = min([10, line("$")])

        keepjumps exe '1,' . n . 's#^\(.\{,10}lastmod\s*: \).*#\1' .
                    \ strftime('%Y-%m-%dT%H:%M:%S+0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
      ]])
      -- local cursor_pos = vim.fn.getpos(".")
      -- local last_line = vim.fn.line("$")
      -- local n = 4 < last_line and 4 or last_line
      -- local keepjumps_exe = '1,' .. n .. 's#^(.{,4}updated\s*: ).*#\1' .. vim.fn.strftime('%Y-%m-%d %H:%M:%S +0900') .. '#e'
      -- vim.fn.keepjumps(exe, keepjumps_exe)

      -- vim.fn.call(vim.fn.histdel, {'search', -1})
      -- vim.fn.call(vim.fn.setpos, {'.', cursor_pos})
    end
  end

  local new_template = function()
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

    if vim.fn.line("$") > 1 then
      return
    end

    local template = {
      "#+title: " .. vim.fn.expand('%:r'),
      "#+author: Hyunjae Kim",
      "#+date: " .. vim.fn.strftime('%Y-%m-%dT%H:%M:%S+0900'),
      "#+lastmod: " .. vim.fn.strftime('%Y-%m-%dT%H:%M:%S+0900'),
      "",
    }
    vim.fn.call(vim.fn.setline, { 1, template })
    vim.fn.execute('normal! G')
    vim.fn.execute('normal! $')
  end

  vim.api.nvim_create_autocmd({
    "BufRead", "BufNewFile"
  }, {
    pattern = { "*.org" },
    callback = new_template
  })

  vim.api.nvim_create_autocmd({
    "BufWritePre"
  }, {
    -- pattern = {"*wiki/*.md"},
    pattern = { "*.org" },
    callback = last_modified
  })
  -- global mappings
  local status_wk, wk = pcall(require, "which-key")
  if status_wk then
    wk.register({
      a = "agenda-prompt",
      c = "capture-prompt"
    }, { prefix = "<Leader>o", buffer = 0 }
    )
  end
end


-- local status_bullets, org_bullets = pcall(require, "org-bullets")
-- if status_bullets then
--   org_bullets.setup({
--     symbols = { "◉", "○", "✸", "✿" }
--   })
-- end
