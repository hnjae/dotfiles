local M = {}

M.unavailable = {
  -- [vim.lsp.buf.range_formatting] = true
  -- [vim.lsp.buf.range_formatting] = true
  [vim.lsp.buf.formatting] = true
}

M.opts = {
  -- python = {
  --   analysis = {
  --     autoSearchPaths = true,
  --     diagnosticMode = "workspace",
  --     useLibraryCodeForTypes = true
  --   }
  -- }

  settings = {
    python = {
      analysis = {
        extraPaths = {"/Users/kakao/remote/infra-handler"}
      }
    }
  }

}

return M
