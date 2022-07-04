-- if packer_plugins and packer_plugins['tagbar'] and packer_plugins['tagbar'].loaded then
if _IS_PLUGIN('tagbar') then
  -- vim.g.tagbar_ctags_bin = "/usr/local/Cellar/universal-ctags/p5.9.20220626.0/bin/ctags"
  -- vim.cmd([[
  -- autocmd filetype snippets let b:tagbar_ignore = 1
  -- ]])

  -- let g:tagbar_position = "rightbelow"
  -- default: 40
  vim.g.tagbar_width = 26
  vim.g.tagbar_wrap = 0 -- enable wrap


  -- let g:tagbar_height = 10
  -- let g:tagbar_previewwin_pos = ""

  -- default: 1 (use maximum width)
  --          0 (logest visible tag)
  vim.g.tagbar_zoomwidth = 0

  -- vim.g.tagbar_compact = 0
  vim.g.tagbar_indent = 1
  vim.g.tagbar_show_data_type = 1

  vim.g.tagbar_help_visiblity = 1
  vim.g.tagbar_show_balloon = 1


  -- vim.g.tagbar_show_linenumbers = -1
  -- vim.b.tagbar_highlight_follow_insert = 1

  vim.g.tagbar_type_asciidoctor = {
    ['sro'] = '""',
    ['sort'] = 0,
    ['ctagstype'] = 'asciidoc',
    ['kinds'] = {
      'c:chapter:0:1',
      's:section:0:1',
      'S:subsection:0:1',
      't:subsubsection:0:1',
      'T:l4subsection:0:1',
      'u:l5subsection:0:1',
      'a:anchor:0:1',
    },
    ['kind2scope'] = {
      ['c'] = 'chapter',
      ['s'] = 'section',
      ['S'] = 'subsection',
      ['t'] = 'subsubsection',
      ['T'] = 'l4subsection',
      ['u'] = 'l5subsection',
      ['a'] = 'anchor',
    },
    ['scope2kind'] = {
      ['chapter']       = 'c',
      ['section']       = 's',
      ['subsection']    = 'S',
      ['subsubsection'] = 't',
      ['l4subsection']  = 'T',
      ['l5subsection']  = 'u',
      ['anchor']  = 'a',
    },
  }

  -- vim.g.tagbar_type_vimwiki = {
  --   ['sro'] = '""',
  --   ['sort'] = 0,
  --   ['ctagstype'] = 'markdown',
  --   ['kinds'] = {
  --     'c:chapter:0:1',
  --     's:section:0:1',
  --     'S:subsection:0:1',
  --     't:subsubsection:0:1',
  --     'T:l3subsection:0:1',
  --     'u:l4subsection:0:1',
  --   },
  --   ['kind2scope'] = {
  --     ['c'] = 'chapter',
  --     ['s'] = 'section',
  --     ['S'] = 'subsection',
  --     ['t'] = 'subsubsection',
  --     ['T'] = 'l3subsection',
  --     ['u'] = 'l4subsection',
  --   },
  --   ['scope2kind'] = {
  --     ['chapter']       = 'c',
  --     ['section']       = 's',
  --     ['subsection']    = 'S',
  --     ['subsubsection'] = 't',
  --     ['l3subsection']  = 'T',
  --     ['l4subsection']  = 'u',
  --   },
  -- }

  -- vim.cmd([[
  -- g:tagbar_type_vimwiki.kinds = [
  --       \ {'short' : 'c', 'long' : 'chapter',       'fold' : 0, 'stl' : 1},
  --       \ {'short' : 's', 'long' : 'section',       'fold' : 0, 'stl' : 1},
  --       \ {'short' : 'S', 'long' : 'subsection',    'fold' : 0, 'stl' : 1},
  --       \ {'short' : 't', 'long' : 'subsubsection', 'fold' : 0, 'stl' : 1},
  --       \ {'short' : 'T', 'long' : 'l3subsection',  'fold' : 0, 'stl' : 1},
  --       \ {'short' : 'u', 'long' : 'l4subsection',  'fold' : 0, 'stl' : 1},
  --   \ ]
  -- ]])


  -- tagbar의 markdown 에서 내용 복사해 옴.
  -- vim.g.tagbar_type_vimwiki = {
  --   -- ['sro'] = '""',
  --   ['sort'] = 0,
  --   -- ['ctagstype'] = 'markdown',
  --   ['kinds'] = {
  --     -- 'h:Heading'
  --     'c:chapter:0:1',
  --     's:section:0:1',
  --     'S:subsection:0:1',
  --     't:subsubsection:0:1',
  --     'T:l3subsection:0:1',
  --     'u:l4subsection:0:1',
  --     {['short'] = 'c', ['long'] = 'chapter',       ['fold'] = 0, ['stl'] = 1},
  --     {['short'] = 's', ['long'] = 'section',       ['fold'] = 0, ['stl'] = 1},
  --     {['short'] = 'S', ['long'] = 'subsection',    ['fold'] = 0, ['stl'] = 1},
  --     {['short'] = 't', ['long'] = 'subsubsection', ['fold'] = 0, ['stl'] = 1},
  --     {['short'] = 'T', ['long'] = 'l3subsection',  ['fold'] = 0, ['stl'] = 1},
  --     {['short'] = 'u', ['long'] = 'l4subsection',  ['fold'] = 0, ['stl'] = 1},
  --   },
  --   ['kind2scope'] = {
  --     ['c'] = 'chapter',
  --     ['s'] = 'section',
  --     ['S'] = 'subsection',
  --     ['t'] = 'subsubsection',
  --     ['T'] = 'l3subsection',
  --     ['u'] = 'l4subsection',
  --   },
  --   ['scope2kind'] = {
  --     ['chapter']       = 'c',
  --     ['section']       = 's',
  --     ['subsection']    = 'S',
  --     ['subsubsection'] = 't',
  --     ['l3subsection']  = 'T',
  --     ['l4subsection']  = 'u',
  --   },
  -- }


  -- https://johngrib.github.io/wiki/vim-tagbar-with-markdown/
  -- 한편 자동 세션 저장 기능을 사용하고 있을 때 tagbar가 열려 있는 상태에서 vim을 종료하고 다시 실행하면 tagbar가 일시적으로 제대로 작동하지 못하는 문제가 발생할 수 있다.
  -- 이런 경우, 다음과 같이 자동으로 tagbar를 종료하고 열어주는 augroup을 만들면 문제를 해결할 수 있다. 아래의 예제는 마크다운 파일을 편집하는 경우에만 tagbar 자동 종료/실행이 작동하도록 되어 있다.
  -- vim.cmd([[
  -- " augroup vimwiki_tagbar
  -- "   autocmd BufRead,BufNewFile *wiki/*.md TagbarOpen
  -- "   autocmd VimLeavePre *.md TagbarClose
  -- " augroup END
  --   " \ 'kinds' : [
  --   "   \ 'h:Heading'
  --   " \ ],
  --   " \ 'sort': 0
  -- ]])
end
