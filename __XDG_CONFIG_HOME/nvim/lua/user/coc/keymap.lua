local M = {}

-- TODO: add codeaction <2022-07-04, Hyunjae Kim>
-- local status_tscope, t_builtin= pcall(require, "telescope.builtin")
local status_wk, wk = pcall(require, "which-key")

if not status_wk then
  M.setup = function() end
  return M
end


local show_documentation = function()
  vim.cmd([[
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
  ]])
  -- if vim.fn.CocAction("hasProvider", "hover") then
  --   vim.fn.CocActionAsync("doHover")
  -- else
  --   vim.fn.feedkeys("K", "in")
  -- end
  -- TODO: implement this in lua <2022-07-04, Hyunjae Kim>
  -- if (index(['vim','help'], &filetype) >= 0)
  --   execute 'h '.expand('<cword>')
  -- else
end

-- ["=="] = { "<plug>(coc-format-selected)", 'coc-format-selected' },

local Nkeymap = {
  -- replace default gd
  -- 0, { severity = {min=vim.diagnostic.severity.WARN} }
  ["[w"] = { "<plug>(coc-diagnostic-prev)", "warning" },
  ["]w"] = { "<plug>(coc-diagnostic-next)", "warning" },
  ["[g"] = { "<plug>(coc-diagnostic-prev-error)", "error" },
  ["]g"] = { "<plug>(coc-diagnostic-next-error)", "error" },
  ["gd"] = { "<Plug>(coc-definition)", 'coc-definition' },
  ["gD"] = { "<Plug>(coc-declaration)", 'coc-declaration' },
  ["K"] = { "show_documentation", 'show-documentation' },
  ["=="] = { "<plug>(coc-format)", 'coc-format' },
  --
  ["gli"] = { "<Plug>(coc-implementation)", 'coc-implementation' },
  -- ["glt"] = { vim.lsp.buf.type_definition, 'lsp-type-definition' },
  ["glr"] = { "<Plug>(coc-references)", 'coc-references' },
  -- ["gls"] = { vim.lsp.buf.signature_help, 'lsp-signature-help' },
  --
  [_LANG_PREFIX .. "l"] = { name = '+lsp' },
  [_LANG_PREFIX .. "ln"] = { "<Plug>(coc-rename)", 'coc-rename' },
  [_LANG_PREFIX .. "la"] = { "<Plug>(coc-codeaction)", 'coc-code-action' },
  -- [_LANG_PREFIX .. "lw"] = { name = '+lsp-workspace' },
  -- [_LANG_PREFIX .. "lwa"] = { vim.lsp.buf.add_workspace_folder, 'lsp-add-workspace' },
  -- [_LANG_PREFIX .. "lwr"] = { vim.lsp.buf.remove_workspace_folder, 'lsp-remove-workspace' },
  -- [_LANG_PREFIX .. "lwl"] = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'lsp-list-workspace' },
  --
  -- coc specific
  --
  -- ["Zl"] = {
  --   function()
  --     for _, buf_client in pairs(vim.lsp.buf_get_clients()) do
  --       buf_client.stop()
  --     end
  --   end,
  --   'stop-lsp'
  -- },
}
local Vkeymap = {
  -- ["=="] = { vim.lsp.buf.range_formatting, 'lsp-formatting' },
  -- [_LANG_PREFIX .. "la"] = { vim.lsp.buf.range_code_action, 'lsp-code-action' },
}

local XNkeymap = {
  -- [_LANG_PREFIX .. "la"] = { "<Plug>(coc-codeaction-selected)", 'lsp-code-action' },
}
----------------------------------------------------------------
-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
----------------------------------------------------------------
local XOkeymap = {
  ["if"] = {"<Plug>(coc-funcobj-i)", "inside-function"},
  ["af"] = {"<Plug>(coc-funcobj-a)", "around-function"},
  ["ic"] = {"<Plug>(coc-classobj-i)", "inside-function"},
  ["ac"] = {"<Plug>(coc-classobj-a)", "inside-function"},
}
-- local Telescope_keymap = {
--   name = "+telescope-lsp",
--   ["r"] = { t_builtin.lsp_references, "references" },
--   ["w"] = { t_builtin.diagnostics, "diagnostics" },
--   ["i"] = { t_builtin.lsp_implementations, "implementation" },
--   ["d"] = { t_builtin.lsp_definitions, "definition" },
--   ["t"] = { t_builtin.lsp_type_definitions, "type-definition" },
--   ["s"] = { name = "+symbols" },
--   ["sd"] = { t_builtin.lsp_document_symbols, "document-symbols" },
--   ["sw"] = { t_builtin.lsp_workspace_symbols, "workspace-symbols" },
--   ["sW"] = { t_builtin.lsp_workspace_symbols, "all-workspace-symbols" },
-- }



-- local register_keymap = function(client_name, keymap, opts)
--   local has_lsp_settings, lsp_settings = pcall(require, 'user.lsp.settings.' .. client_name)

--   if not has_lsp_settings or not lsp_settings.unavailable then
--     wk.register(keymap, opts)
--     return
--   end

--   for lhs, rhs_capsuled in pairs(keymap) do
--     if not lsp_settings.unavailable[rhs_capsuled[1]] then
--       wk.register(
--         { [lhs] = rhs_capsuled, },
--         opts
--       )
--     end
--   end
-- end


M.setup = function()
  -- buffer = bufnr
  wk.register(Nkeymap, { mode = "n", silent = true, noremap = true, })
  wk.register(Vkeymap, { mode = "v", silent = true, noremap = true, })
  wk.register(XOkeymap, { mode = "x", silent = true, noremap = true, })
  wk.register(XOkeymap, { mode = "o", silent = true, noremap = true, })

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

return M
