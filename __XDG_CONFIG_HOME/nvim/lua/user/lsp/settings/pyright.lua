local gen_custom_opts = function(path)
  return {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
end

return gen_custom_opts
