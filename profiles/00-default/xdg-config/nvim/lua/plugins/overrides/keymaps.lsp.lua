-- RESTORE SOME NEOVIM'S DEFAULT KEYMAPS

---@type LazySpec
return {
  [1] = "nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      ["*"] = {
        keys = {
          --[[
                                                      *grr* *gra* *grn* *gri*
            Some keymaps are created unconditionally when Nvim starts:
            - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
            - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
            - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
            - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
            - "gO" `vim.lsp.buf.document_symbol()` or `Man` or table of contents
          ]]

          -- neovim 빌트인 바인딩과 중복되는 키맵 제거.
          { "<Leader>cr", false }, -- use `grn` instead (LazyVim 14)
          { "gr", false }, -- use `grr` instead (LazyVim 14)
          { "gI", false }, -- use `gri` instead (LazyVim 14)
          { "<Leader>ca", false }, -- use `gra` instead (LazyVim 14)
          { "<c-k>", false }, -- use `<c-s>` instead (LazyVim 14)
          { "gK", false }, -- use `<c-s>` instead (signature help)
          --

          -- neovim 빌트인 바인딩과 유사하게 키맵 설정.
          {
            "grN",
            function()
              Snacks.rename.rename_file()
            end,
            desc = "Rename File",
          },
          { "<Leader>cR", false }, -- use `grN` instead
          { "grA", LazyVim.lsp.action.source, desc = "Source Action" },
          { "<Leader>cA", false }, -- use `grA` instead

          { "<leader>cc", false },
          { "<leader>cC", false },
          { "grc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" } },
          {
            "grC",
            vim.lsp.codelens.refresh,
            desc = "Refresh & Display Codelens",
            mode = { "n" },
            has = "codeLens",
          },

          { "gy", false },
          { "gd", false },
          { "gry", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
          { "grd", vim.lsp.buf.definition, desc = "Goto Definition" },

          { "gD", false },
          { "grD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        },
      },
    },
  },
}
