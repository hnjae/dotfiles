if packer_plugins['coq_nvim'] and packer_plugins['coq_nvim'].loaded then


  vim.g.coq_settings = {
    auto_start = true,
    -- Set recommended to false
    keymap = {
      recommended = false,
      manual_complete = "<C-Space>",
      bigger_preview = "<C-k>",
      jump_to_mark = "<C-h>",
      -- repeat = nil,
      -- eval_snips = nil,
    },
  }
  -- vim.keymap.set("i", "<ESC>", vim.fn.pumvisible() != 0 and "<C-e><ESC>" or "<ESC>")
  -- vim.api.nvim_set_keymap("i", "<ESC>", vim.fn.pumvisible() != 0 and "<C-e><ESC>" or "<ESC>", {})
  -- vim.api.nvim_set_keymap("i", "<ESC>", vim.cmd([[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]]), {})
  -- vim.api.nvim_set_keymap("i", "<ESC>", "<C-e><ESC>", {})


  vim.cmd([[
  ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
  ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
  ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
  ino <silent><expr> <C-w>   pumvisible() ? "\<C-e><C-w>"  : "\<C-w>"
  ino <silent><expr> <C-u>   pumvisible() ? "\<C-e><C-w>"  : "\<C-u>"
  ino <silent><expr> <Tab>   pumvisible() ? (complete_info().selected == -1 ? "\<C-e><Tab>" : "\<C-y>") : "\<Tab>"
  ]])
  -- " ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
  -- ino <silent><expr> <TAB>   pumvisible() ? (complete_info(['selected']).selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<TAB>"

 -- " ino <silent><expr> <CR>    pumvisible() ? (complete_info(['']).selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
  -- ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  -- ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

end
