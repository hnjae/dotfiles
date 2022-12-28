local M = {}

-- local status_tscope, t_builtin= pcall(require, "telescope.builtin")
local status_wk, wk = pcall(require, "which-key")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ghd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

  -- if vim.b[bufnr]._is_lsp_keymap then
  --   return
  -- end
  -- vim.b[bufnr]._is_lsp_keymap = true
-- ["Zl"] = {
--   function()
--     for _, buf_client in pairs(vim.lsp.buf_get_clients()) do
--       buf_client.stop()
--     end
--   end,
--   'stop-lsp'
-- },
-- 0, { severity = {min=vim.diagnostic.severity.WARN} }

local coc_show_documentation = function()
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
  if not status_wk then
    return
  end
  -- buffer = bufnr

  ------------------------------------------------------------------------------
  -- n keymap
  ------------------------------------------------------------------------------
  if _IS_PLUGIN("coc.nvim") then
    local nkeymap = {
      -- replace default gd
      ["K"] = { coc_show_documentation, 'show-documentation' },
      ["=="] = { "<plug>(coc-format)", 'coc-format' },
    }
    wk.register(nkeymap, { mode = "n", silent = true, noremap = true, })
  else
    local nkeymap = {
      -- replace default gd
      ["K"] = { vim.lsp.buf.hover, 'lsp-declaration' },
      ["=="] = { vim.lsp.buf.formatting, 'lsp-formatting' },
    }
    wk.register(nkeymap, { mode = "n", silent = true, noremap = true, })
  end

  ------------------------------------------------------------------------------
  -- v keymap
  ------------------------------------------------------------------------------
  if _IS_PLUGIN("coc.nvim") then
    local vkeymap = {
      ["=="] = { "<plug>(coc-format-selected)", 'coc-format-selected' },
    }
    wk.register(vkeymap, { mode = "v", silent = true, noremap = true, })
  else
    local vkeymap = {
      ["=="] = { vim.lsp.buf.range_formatting, 'lsp-formatting' },
    }
    wk.register(vkeymap, { mode = "v", silent = true, noremap = true, })
  end

  ----------------------------------------------------------------
  -- Map function and class text objects
  -- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  ----------------------------------------------------------------
  local XOkeymap = {
    ["if"] = { "<Plug>(coc-funcobj-i)", "inside-function" },
    ["af"] = { "<Plug>(coc-funcobj-a)", "around-function" },
    ["ic"] = { "<Plug>(coc-classobj-i)", "inside-function" },
    ["ac"] = { "<Plug>(coc-classobj-a)", "inside-function" },
  }
  wk.register(XOkeymap, { mode = "x", silent = true, noremap = true, })
  wk.register(XOkeymap, { mode = "o", silent = true, noremap = true, })

  ------------------------------------------------------------------------------
  ----------------------------------------------------------------
  wk.register({
    ["Zl"] = {
      function()
        for _, buf_client in pairs(vim.lsp.buf_get_clients()) do
          buf_client.stop()
        end
      end,
      'stop-lsp'
    },
  },
    { mode = "n", silent = true, noremap = true }

  )
end

return M
