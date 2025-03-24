-- Dadbod is a Vim plugin for interacting with databases.

---@type LazySpec
return {
  [1] = "kristijanhusak/vim-dadbod-ui",
  lazy = true,
  cond = not vim.g.vscode,
  dependencies = {
    {
      -- database interface
      "tpope/vim-dadbod",
    },
    {
      "kristijanhusak/vim-dadbod-completion",
    },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
  },
  init = function()
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_use_nerd_fonts = 1
    -- TODO: manual mapping <2023-01-16, Hyunjae Kim>
    -- o / <CR> - Open/Toggle Drawer options (<Plug>(DBUI_SelectLine))
    -- S - Open in vertical split (<Plug>(DBUI_SelectLineVsplit))
    -- d - Delete buffer or saved sql (<Plug>(DBUI_DeleteLine))
    -- R - Redraw (<Plug>(DBUI_Redraw))
    -- A - Add connection (<Plug>(DBUI_AddConnection))
    -- H - Toggle database details (<Plug>(DBUI_ToggleDetails))

    -- For queries, filetype is automatically set to sql. Also, two mappings is added for the sql filetype:
    -- <Leader>W - Permanently save query for later use (<Plug>(DBUI_SaveQuery))
    -- <Leader>E - Edit bind parameters (<Plug>(DBUI_EditBindParameters))

    -- vim.api.nvim_create_autocmd(
    --   { 'FileType' },
    --   {
    --     pattern = { 'dbui' },
    --     callback = function()
    --       vim.keymap.set(
    --         'n', 'o', "<Plug>(DBUI_SelectLine)", { buffer = true, desc = "dbui-SelectLine" }
    --       )
    --       vim.keymap.set(
    --         'n', '<CR>', "<Plug>(DBUI_SelectLine)", { buffer = true, desc = "dbui-SelectLine" }
    --       )
    --       vim.keymap.set(
    --         'n', 'R', "<Plug>(DBUI_Redraw)", { buffer = true, desc = "dbui-Redraw" }
    --       )
    --     end
    --   }
    -- )
    -- vim.api.nvim_create_autocmd(
    --   { 'FileType' },
    --   {
    --     pattern = { 'mysql' },
    --     callback = function()
    --       vim.keymap.set(
    --         'n', 'o', "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "dbui-SelectLine" }
    --       )
    --     end
    --   }
    -- )

    vim.g.db_ui_disable_mappings = 0
  end,
}
