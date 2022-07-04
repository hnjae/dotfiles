-- EXTEND DEFAULT KEYMAP

if packer_plugins and packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded then
  local wk = require("which-key")

  ----------------------------------------------------------------
  -- ]/[: Misc
  ----------------------------------------------------------------
  -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  --   ":<C-u>call CocAction('diagnosticPrevious', 'error')<CR>", {})

  ----------------------------------------------------------------
  -- gh
  ----------------------------------------------------------------
  -- definition을 새 탭에 열지 말지,
  -- 그런 설정은 `coc.preferences.jumpCommand` 로 설정이 가능
  -- 또는 :call CocAction('jumpDefinition', 'tab drop') 식으로 수동 지정이 가능
  vim.api.nvim_set_keymap("n", "ghy", "<plug>(coc-type-definition)", {})
  wk.register({ ["ghy"] = "type-definition" })

  -- vim.api.nvim_set_keymap("n", "ghu", "<plug>(coc-references-used)", {})
  -- wk.register({["ghu"] = "references-used"})


  ----------------------------------------------------------------
  -- codeaction
  ----------------------------------------------------------------
  -- let g:which_key_map.m.a = {'name': '+codeaction'}
  -- vim.cmd([[
  -- " Applying codeAction to the selected region.
  -- " Example: `<leader>aap` for current paragraph
  -- xnoremap sa  <Plug>(coc-codeaction-selected)
  -- nnoremap sa  <Plug>(coc-codeaction-selected)

  -- " Remap keys for applying codeAction to the current buffer.
  -- nnoremap sac  <Plug>(coc-codeaction)
  -- " Apply AutoFix to problem on the current line.
  -- nnoremap sqf  <Plug>(coc-fix-current)

  -- " Run the Code Lens action on the current line.
  -- nnoremap scl  <Plug>(coc-codelens-action)
  -- ]])


  ----------------------------------------------------------------
  -- scroll coc-float window
  ----------------------------------------------------------------
  -- Remap <C-f> and <C-b> for scroll float windows/popups.
  -- float window 없을때는 정상 작동.
  vim.cmd([[
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  ]])

  ----------------------------------------------------------------
  -- Use CTRL-S for selections ranges.
  -- Requires 'textDocument/selectionRange' support of language server.
  -- nnoremap <silent> <C-s> <Plug>(coc-range-select)
  -- xnoremap <silent> <C-s> <Plug>(coc-range-select)

  ----------------------------------------------------------------
  -- Add `:Fold` command to fold current buffer.
  vim.cmd([[
  command! -nargs=? Fold :call CocAction('fold', <f-args>)
  ]])
  ----------------------------------------------------------------
end
