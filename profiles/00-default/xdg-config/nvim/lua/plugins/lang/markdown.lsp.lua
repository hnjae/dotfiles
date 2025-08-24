---@type LazySpec[]
return {
  {
    [1] = "nvim-lspconfig",
    optional = true,
    -- ---@type lspconfig.options
    opts = {
      servers = {
        marksman = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx)
              --[[
                Example of result.diagnostics:
                  {
                    {
                      code = "2",
                      message = "Link to non-existent document '<foo>'",
                      range = {
                        ["end"] = {
                          character = 21,
                          line = 52
                        },
                        start = {
                          character = 12,
                          line = 52
                        }
                      },
                      severity = 1,
                      source = "Marksman"
                    }
                  }
              ]]
              -- Lower the severity
              if result and result.diagnostics then
                vim.tbl_map(function(diagnostic)
                  diagnostic.severity = vim.diagnostic.severity.HINT
                  return diagnostic
                end, result.diagnostics)
              end

              -- Call the default handler
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
            end,
          },
        },
      },
    },
  },
}
