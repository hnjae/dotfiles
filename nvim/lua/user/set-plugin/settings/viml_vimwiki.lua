local M = {}
M.setup = function ()
  if not _IS_PLUGIN('vimwiki') then
    return
  end

  -- if packer_plugins and packer_plugins['vimwiki'] then
  ----------------------------------------------------------------------------
  -- CONCEAL
  ----------------------------------------------------------------------------
  -- default: 2
  vim.g.vimwiki_conceallevel = 0
  vim.g.vimwiki_conceal_pre = 0
  vim.g.vimwiki_conceal_onechar_markers = 0
  vim.g.vimwiki_url_maxsave = 0

  vim.g.vimwiki_list = {
    {
      ext = ".md",
      path = "~/Sync/Library/wiki_md",
      syntax = "markdown"
    },
    {
      diary_rel_path = ".",
      ext = ".md",
      path = "~/Sync/xianblue.github.io/_wiki",
      syntax = "markdown"
    },
    -- {
    --   ext = ".wiki",
    --   path = "~/Sync/Library/wiki-test",
    --   -- syntax = "markdown"
    -- },
  }

  -- g:vimwiki_list 경로에 있지 않은 *.md 파일을 모두 vimwiki 형식으로 인식하는 문제 해결 (set it to 0)
  vim.g.vimwiki_global_ext = 0
  -- let g:vimwiki_folding = 'list'
  -- let g:vimwiki_listsym_rejected = '✗'
  -- let g:vimwiki_listsyms = ' ○◐●✓' : 이러한 기호 쓰면 GFM 이랑 호환이 안된다.

  ----------------------------------------------------------------------------
  -- MISC
  ----------------------------------------------------------------------------
  vim.g.md_modify_disabled = 0
  vim.g.vimwiki_diary_months = {
    ['1'] = "1월",
    ['2'] = "2월",
    ['3'] = "3월",
    ['4'] = "4월",
    ['5'] = "5월",
    ['6'] = "6월",
    ['7'] = "7월",
    ['8'] = "8월",
    ['9'] = "9월",
    ['10'] = "10월",
    ['11'] = "11월",
    ['12'] = "12월"
  }

  ----------------------------------------------------------------------------
  -- Mappings
  ----------------------------------------------------------------------------
  vim.g.vimwiki_key_mappings = {
    ['all_maps'] = 1,

    -- vimwiki 언제든지 열수 있는 단축키 설정.
    -- 수동으로 설정하자.
    ['global'] = 0,

    -- ]= [=: signature-mark-any 랑 충돌해서 수동할당
    ['headers'] = 0,

    -- ['text_objs'] = 0
    -- ['table_format'] = 0

    -- Vimwiki의 테이블 단축키(<Tab>)를 사용하지 않도록 한다
    -- UltiSnips랑 충돌 해결
    ['table_mappings'] = 0,

    -- 각종 충돌 해결 위해 수동할당
    ['lists'] = 0,

    -- 몇몇 키 prefix 교체 위해
    ['links'] = 0,

    -- vimwiki format을 안사용해서 disable 할것
    ['html'] = 0,

    -- mouse: disabled by default
    -- ['mouse'] = 0,
  }

  ----------------------------------------------------------------------------
  -- F4 키를 누르면 커서가 놓인 단어를 위키에서 검색한다
  -- nnoremap <F4> :execute "VWS /" . expand("<cword>") . "/" <Bar> :lopen<CR>
  -- Shift F4 키를 누르면 현재 문서를 링크한 모든 문서를 검색한다
  -- nnoremap <S-F4> :execute "VWB" <Bar> :lopen<CR>
  ----------------------------------------------------------------------------
  -- augroup vimwikiauto
  --     " <C-s> 로 테이블에서 오른쪽 컬럼으로 이동한다.
  --     autocmd FileType vimwiki inoremap <C-s> <C-r>=vimwiki#tbl#kbd_tab()<CR>
  --     " <C-a> 로 테이블에서 왼쪽 컬럼으로 이동한다.
  --     autocmd FileType vimwiki inoremap <C-a> <Left><C-r>=vimwiki#tbl#kbd_shift_tab()<CR>
  -- augroup END

  -- If buffer modified, update any 'Last modified: ' in the first 20 lines.
  -- 'Last modified: ' can have up to 10 characters before (they are retained).
  -- Restores cursor and window position using save_cursor variable.
  local last_modified = function()
    -- if vim.opt.filetype:get() ~= "vimwiki" then
    --   return
    -- end

    if vim.opt.modified:get() then
      vim.cmd([[
        let save_cursor = getpos(".")
        let n = min([10, line("$")])

        keepjumps exe '1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
                    \ strftime('%Y-%m-%dT%H:%M:%S+0900') . '#e'
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

    if vim.fn.line("$") > 1 then
      return
    end

    local template = {
      "---",
      "title   : ",
      "author  : Hyunjae Kim",
      "date    : " .. vim.fn.strftime('%Y-%m-%dT%H:%M:%S+0900'),
      "lastmod : " .. vim.fn.strftime('%Y-%m-%dT%H:%M:%S+0900'),
      "---",
      "",
    }
    -- print(vim.inspect(template))
    vim.fn.call(vim.fn.setline, { 1, template })
    vim.fn.execute('normal! G')
    vim.fn.execute('normal! $')
  end


  -- local vimwikiauto = vim.api.nvim_create_augroup("vimwikiauto")
  vim.api.nvim_create_autocmd({
    "BufRead", "BufNewFile"
  }, {
    -- pattern = {"*wiki/*.md"},
    pattern = { "*.md" },
    callback = new_template
  })

  vim.api.nvim_create_autocmd({
    "BufWritePre"
  }, {
    -- pattern = {"*wiki/*.md"},
    pattern = { "*.md" },
    callback = last_modified
  })
end

return M
