local M = {}
local status_wk, wk = pcall(require, "which-key")
-- local status_hop, hop = pcall(require, "hop")

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

  wk.register({
    ["gd"] = { vim.lsp.buf.definition, 'lsp-definition' },
    ["gD"] = { vim.lsp.buf.declaration, 'lsp-declaration' },
    ["gl"] = { name="+lsp" },
    -- ["glu"] = { "<plug>(coc-references-used)", "references-used" },
    ["gli"] = { vim.lsp.buf.implementation, 'lsp-implementation' },
    ["glr"] = { vim.lsp.buf.references, 'lsp-references' },
    ["gly"] = { vim.lsp.buf.type_definition, 'lsp-type-definition' },

    ["gls"] = { vim.lsp.buf.signature_help, 'lsp-signature-help' },
  }, { mode = "n" })

end

return M
