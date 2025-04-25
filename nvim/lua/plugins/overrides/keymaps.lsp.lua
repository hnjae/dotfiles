-- RESTORE SOME NEOVIM'S DEFAULT KEYMAPS

---@type LazySpec
return {
  [1] = "nvim-lspconfig",
  optional = true,
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    --                                           *grr* *gra* *grn* *gri*
    -- Some keymaps are created unconditionally when Nvim starts:
    -- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
    -- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
    -- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
    -- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|

    keys[#keys + 1] = { "gr", false } -- { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    keys[#keys + 1] = { "gI", false } -- { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
    -- keys[#keys + 1] = { "gd", false } -- { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
    -- keys[#keys + 1] = { "gD", false } -- { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    -- keys[#keys + 1] = { "gy", false } -- { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },

    -- keys[#keys + 1] = { "grr", "<cmd>Trouble lsp_references<CR>" } -- default: opens quickfix
    -- keys[#keys + 1] = { "gri", "<cmd>Trouble lsp_implementations<CR>" } -- default: opens quickfix
  end,
}
