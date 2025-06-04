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

    -- neovim 빌트인 바인딩과 중복되는 키맵 제거.
    keys[#keys + 1] = { "<Leader>cr", false } -- use `grn` instead (LazyVim 14)
    keys[#keys + 1] = { "gr", false } -- use `grr` instead (LazyVim 14)
    keys[#keys + 1] = { "gI", false } -- use `gri` instead (LazyVim 14)
    keys[#keys + 1] = { "<Leader>ca", false } -- use `gra` instead (LazyVim 14)
    keys[#keys + 1] = { "<c-k>", false } -- use `<c-s>` instead (LazyVim 14)

    -- neovim 빌트인 바인딩과 유사하게 키맵 설정.
    keys[#keys + 1] = {
      "grN",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    }
    keys[#keys + 1] = { "<Leader>cR", false } -- use `grN` instead
    keys[#keys + 1] = { "grA", LazyVim.lsp.action.source, desc = "Source Action" }
    keys[#keys + 1] = { "<Leader>cA", false } -- use `grA` instead

    keys[#keys + 1] = {
      "gS",
      function()
        return vim.lsp.buf.signature_help()
      end,
      desc = "Signature Help",
      has = "signatureHelp",
    }
    keys[#keys + 1] = { "gK", false } -- use `gS` instead

    keys[#keys + 1] = { "<leader>cc", false }
    keys[#keys + 1] = { "<leader>cC", false }
    keys[#keys + 1] = { "grc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" } }
    keys[#keys + 1] = {
      "grC",
      vim.lsp.codelens.refresh,
      desc = "Refresh & Display Codelens",
      mode = { "n" },
      has = "codeLens",
    }

    keys[#keys + 1] = { "gy", false }
    keys[#keys + 1] = { "gd", false }
    keys[#keys + 1] = { "gry", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" }
    keys[#keys + 1] = { "grd", vim.lsp.buf.definition, desc = "Goto Definition" }

    keys[#keys + 1] = { "gD", false }
    keys[#keys + 1] = { "grD", vim.lsp.buf.declaration, desc = "Goto Declaration" }
  end,
}
