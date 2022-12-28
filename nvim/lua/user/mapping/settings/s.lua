local M = {}
local status_wk, wk = pcall(require, "which-key")

_LANG_PREFIX = "s"

M.setup = function()
  if not status_wk then
    return
  end

  -- disable s/S, use c/0C instead
  vim.cmd([[
    nmap s <Nop>
    xmap s <Nop>
    vmap s <Nop>
    omap s <Nop>
  ]])

  wk.register({
    [_LANG_PREFIX] = { name="+lang" }
  })

  -- wk.register({
  --   [_LANG_PREFIX] = {
  --     -- c = { name = "+execute" },
  --     -- d = { name = "+debug" },
  --     -- difine bottom
  --     -- r = { name = "+refactor" },
  --     -- h = { name = "+help" },
  --     -- g = { name = "+goto" },
  --     mode = 'n'
  --   },
  -- })


  -----------------------------------------------------------------------------
  -- lsp
  -----------------------------------------------------------------------------
  if _IS_PLUGIN("coc.nvim") then
    wk.register({
      name = "+lsp",
      ["n"] = { "<Plug>(coc-rename)", 'coc-rename' },
      ["a"] = { "<Plug>(coc-codeaction)", 'coc-code-action' },
    }, {prefix = _LANG_PREFIX .. "l"})
    wk.register({
      name = "+lsp",
      ["a"] = "<plug>(coc-codeaction-selected)",
    }, {mode = "v", prefix = _LANG_PREFIX .. "l"})
  else
    wk.register({
      name = "+lsp",
      ["n"] = {"vim.lsp.buf.rename", "lsp-rename"},
      ["a"] = {"vim.lsp.buf.code_action", "lsp-code-action"},
      ["w"] = { name = '+lsp-workspace' },
      ["wa"] = { vim.lsp.buf.add_workspace_folder, 'lsp-add-workspace' },
      ["wr"] = { vim.lsp.buf.remove_workspace_folder, 'lsp-remove-workspace' },
      ["wl"] = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'lsp-list-workspace' },
    }, {mode = "n", prefix = _LANG_PREFIX .. "l"})
    wk.register({
      name = "+lsp",
      ["a"] = {"vim.lsp.buf.range_code_action", "lsp-code-action"},
    }, {mode = "v", prefix = _LANG_PREFIX .. "l"})
    -- local XNkeymap = {
      -- [_LANG_PREFIX .. "la"] = { "<Plug>(coc-codeaction-selected)", 'lsp-code-action' },
    -- }
  end

  -----------------------------------------------------------------------------
  -- coc specific features
  -----------------------------------------------------------------------------
  if _IS_PLUGIN("coc.nvim") then
    wk.register({
      ["r"] = {
        name = "+refactor",
        -- refactor: Open refactor window
        r = { "<plug>(coc-refactor)", "refactor-win", mode = "n" },
        I = { "<cmd>CocAction('organizeImport')<CR>", "sort-imports", mode = "n" },
        -- I = { ":call CocAction('organizeImport')<CR>", "sort-imports", mode = "n" },
        -- TODO: 화면 갱신 할 것 <2022-04-14, Hyunjae Kim>
        s = { ":CocSearch ", "search", mode = "n" },
      }
    }, {prefix = _LANG_PREFIX})
  end

  -----------------------------------------------------------------------------
  -- Fuzzy features
  -----------------------------------------------------------------------------
  if _IS_PLUGIN("coc-fzf") then
    wk.register(
      {
        name = "+coc-fzf",
        ["<Space>"] = {"<cmd>CocFzfList<CR>", "coc-fzf-list"},
        ["x"] = {"<cmd>CocFzfList extensions<CR>", "extensions"},
        ["m"] = {"<cmd>CocFzfList commands<CR>", "commands"},
        ["d"] = {"<cmd>CocFzfList diagnostics<CR>", "diagnostics"},
        ["f"] = {"<cmd>CocFzfList folders<CR>", "folders"},
        ["k"] = {"<cmd>CocFzfList links<CR>", "links"},
        ["l"] = {"<cmd>CocFzfList lists<CR>", "lists"},
        ["c"] = {"<cmd>CocFzfList location<CR>", "location"},
        ["o"] = {"<cmd>CocFzfList outline<CR>", "outline"},
        ["v"] = {"<cmd>CocFzfList services<CR>", "services"},
        ["s"] = {"<cmd>CocFzfList symbols<CR>", "symbols"},
        ["y"] = {"<cmd>CocFzfList yank<CR>", "yank"},
        -- ["s"] = {"<cmd>CocFzfList -I symbols<CR>", "symbols"},
      },
      {
        mode="n", silent = true, prefix = _LANG_PREFIX .. "f"
      }
    )
  else
    local status_tscope, t_builtin= pcall(require, "telescope.builtin")
    local telescope_keymap = {
      name = "+telescope-lsp",
      ["d"] = { t_builtin.diagnostics, "diagnostics" },
      ["r"] = { t_builtin.lsp_references, "references" },
      ["i"] = { t_builtin.lsp_implementations, "implementation" },
      ["k"] = { t_builtin.lsp_definitions, "definition" },
      ["t"] = { t_builtin.lsp_type_definitions, "type-definition" },
      ["s"] = { name = "+symbols" },
      ["sd"] = { t_builtin.lsp_document_symbols, "document-symbols" },
      ["sw"] = { t_builtin.lsp_workspace_symbols, "workspace-symbols" },
      ["sW"] = { t_builtin.lsp_workspace_symbols, "all-workspace-symbols" },
    }
    if status_tscope then
      wk.register(
        telescope_keymap,
        {
          mode = "n",
          silent = false,
          noremap = false,
          -- buffer = bufnr,
          prefix= _LANG_PREFIX .. "f"
        }
      )
    end
  end

end

return M
