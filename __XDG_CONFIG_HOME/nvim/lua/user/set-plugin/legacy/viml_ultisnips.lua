-- VIM_DIR/vim-include/

-- Plugin : ultisnips settings
if _IS_PLUGIN('ultisnips') then

  vim.api.nvim_set_keymap("i", "<c-x><c-k>", "<c-x><c-k>", {})

  -- vim.g.UltiSnipsExpandTrigger = '<tab>'
   -- let g:UltiSnipsListSnippets = '<c-tab>'
  vim.g.UltiSnipsJumpForwardTrigger = '<tab>'    -- default: <c-j>
  vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>' -- default: <c-k>
  -- vim.g.UltiSnipsEditSplit = "horizontal" -- if you want

  local ulti_dir = vim.fn.stdpath('config') .. "/UltiSnips"
  vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = ulti_dir

  vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }

  vim.g.UltiSnipsEditSplit = "context"
  vim.g.UltiSnipsEnableSnipMate = 0
end
