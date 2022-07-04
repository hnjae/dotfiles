local wk = require("which-key")

-- vim.api.nvim_set_keymap("", "s", "", "")
wk.register({[_LANG_PREFIX] = {name = "+lang", mode="n"}})
wk.register({[_LANG_PREFIX] = {name = "+lang", mode="v"}})
wk.register({[_LANG_PREFIX] = {name = "+lang", mode="o"}})


if packer_plugins and packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded then

  wk.register({
    [_LANG_PREFIX] = {
      name = "+lang",
      c = { name = "+execute" },
      d = { name = "+debug" },
      -- difine bottom
      -- r = { name = "+refactor" },
      -- h = { name = "+help" },
      -- g = { name = "+goto" },
      mode = 'n'
    },
  })

  ----------------------------------------------------------------
  -- wk.register({ ["s"] = { name = "+lang" } })
  ----------------------------------------------------------------
  wk.register({
    ["r"] = {
      name = "+refactor",
      -- rename symbol
      -- 이건 작동 안됨
      -- r = { ":call CocAction('rename')<CR>", "rename", mode = "n" },

      -- refactor: Open refactor window
      r = { "<plug>(coc-refactor)", "refactor-win", mode = "n" },
      -- f = { ":call CocAction('refactor')<CR>", "refactor", mode = "n" },

      -- i = { ":call CocAction('organizeImport')<CR>", "remove-imports", mode = "n" },
      I = { ":call CocAction('organizeImport')<CR>", "sort-imports", mode = "n" },
      -- autocmd FileType python nmap srI :CocCommand pyright.organizeimports<CR>
      -- Add `:OR` command for organize imports of the current buffer.
      -- command! -nargs=0 OR  :call  CocAction('runCommand', 'editor.action.organizeImport')

      -- TODO: 화면 갱신 할 것 <2022-04-14, Hyunjae Kim> --
      -- 화면 갱신해야함.
      s = { ":CocSearch ", "search", mode = "n" },
    }
  }, {prefix = _LANG_PREFIX})
end
