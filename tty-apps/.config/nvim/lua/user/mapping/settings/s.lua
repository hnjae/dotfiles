local M = {}

_LANG_PREFIX = "s"
local status_wk, wk = pcall(require, "which-key")

local coc_setup = function()
  if not _IS_PLUGIN("coc.nvim") then
    return
  end
  vim.cmd([[
    nmap s <Nop>
    xmap s <Nop>
    vmap s <Nop>
    omap s <Nop>
  ]])

  wk.register({
    [_LANG_PREFIX] = {
      c = { name = "+execute" },
      d = { name = "+debug" },
      -- difine bottom
      -- r = { name = "+refactor" },
      -- h = { name = "+help" },
      -- g = { name = "+goto" },
      mode = 'n'
    },
  })

  wk.register({
    ["r"] = {
      name = "+refactor",
      -- rename symbol
      -- 이건 작동 안됨
      -- r = { ":call CocAction('rename')<CR>", "rename", mode = "n" },

      -- refactor: Open refactor window
      r = { "<plug>(coc-refactor)", "refactor-win", mode = "n" },
      -- f = { ":call CocAction('refactor')<CR>", "refactor", mode = "n" },

      I = { ":call CocAction('organizeImport')<CR>", "sort-imports", mode = "n" },
      -- command! -nargs=0 OR  :call  CocAction('runCommand', 'editor.action.organizeImport')

      -- TODO: 화면 갱신 할 것 <2022-04-14, Hyunjae Kim> --
      -- 화면 갱신해야함.
      s = { ":CocSearch ", "search", mode = "n" },
    }
  }, {prefix = _LANG_PREFIX})

  wk.register({
    ["l"] = { name = "+lsp" },
    ["ln"] = { "<Plug>(coc-rename)", 'coc-rename' },
    ["la"] = { "<Plug>(coc-codeaction)", 'coc-code-action' },
-- [_LANG_PREFIX .. "lw"] = { name = '+lsp-workspace' },
-- [_LANG_PREFIX .. "lwa"] = { vim.lsp.buf.add_workspace_folder, 'lsp-add-workspace' },
-- [_LANG_PREFIX .. "lwr"] = { vim.lsp.buf.remove_workspace_folder, 'lsp-remove-workspace' },
-- [_LANG_PREFIX .. "lwl"] = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'lsp-list-workspace' },
  }, {prefix = _LANG_PREFIX})
  local Vkeymap = {
    -- [_LANG_PREFIX .. "la"] = { vim.lsp.buf.range_code_action, 'lsp-code-action' },
  }

  local XNkeymap = {
    -- [_LANG_PREFIX .. "la"] = { "<Plug>(coc-codeaction-selected)", 'lsp-code-action' },
  }

  local coclist_keymap = {
    ["c"] = {"<cmd>CocFzfList<CR>", "coc-fzf-list"},
    --
    ["d"] = {"<cmd>CocFzfList diagnostics<CR>", "diagnostics"},
    ["m"] = {"<cmd>CocFzfList commands<CR>", "commands"},
    ["o"] = {"<cmd>CocFzfList outline<CR>", "outline"},
    ["l"] = {"<cmd>CocFzfList location<CR>", "location"},
    ["y"] = {"<cmd>CocFzfList yank<CR>", "yank"},
    ["v"] = {"<cmd>CocFzfList services<CR>", "services"},
    ["s"] = {"<cmd>CocFzfList -I symbols<CR>", "symbols"},
    ["x"] = {"<cmd>CocFzfList extensions<CR>", "extensions"},
  }
  wk.register(
    {[_LANG_PREFIX .. "c"] = {name = "+coclist"}}
  )
  wk.register(
    coclist_keymap,
    {
      mode="n", silent = true, prefix = _LANG_PREFIX .. "c"
    }
  )
end

M.setup = function()
  if not status_wk then
    return
  end

  -- disable s/S, use c/0C instead
  -- vim.cmd([[
  -- nmap s ""
  -- nmap S ""
  -- ]])

  wk.register({
    [_LANG_PREFIX] = { name="+lang" }
  })

  -- wk.register({[_PREFIX] = {name = "+lang", mode="n"}})
  -- wk.register({[_PREFIX] = {name = "+lang", mode="v"}})
  -- wk.register({[_PREFIX] = {name = "+lang", mode="o"}})

  coc_setup()

end

return M
