local M = {}

-- local status_hop, hop = pcall(require, "hop")

local status_wk, wk = pcall(require, "which-key")

M.setup = function()
  if not status_wk then
    return
  end
  -- make Esc work at terminal. Not working at which-key
  vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {})

  if _IS_PLUGIN("hop") then
    vim.api.nvim_set_keymap('', 'f',
      "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
      , {})
    vim.api.nvim_set_keymap('', 'F',
      "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
      , {})
    vim.api.nvim_set_keymap('', 't',
      "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
      , {})
    vim.api.nvim_set_keymap('', 'T',
      "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>"
      , {})
  end

  if _IS_PLUGIN("coc.nvim") then
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
    wk.register({
      ["gd"] = { "<Plug>(coc-definition)", 'coc-definition' },
      ["gD"] = { "<Plug>(coc-declaration)", 'coc-declaration' },
      ["gl"] = { name="+lsp" },
      ["gly"] = { "<plug>(coc-type-definition)", "type-definition" },
      ["glu"] = { "<plug>(coc-references-used)", "references-used" },
      ["gli"] = { "<Plug>(coc-implementation)", 'coc-implementation' },
      ["glr"] = { "<Plug>(coc-references)", 'coc-references' },
    }, { mode = "n" })

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
  -- Use CTRL-S for selections ranges.
  -- Requires 'textDocument/selectionRange' support of language server.
  -- nnoremap <silent> <C-s> <Plug>(coc-range-select)
  -- xnoremap <silent> <C-s> <Plug>(coc-range-select)



  end


end

return M
