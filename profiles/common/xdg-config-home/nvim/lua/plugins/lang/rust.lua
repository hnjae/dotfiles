---@type LazySpec[]
return {
  {
    [1] = "rustaceanvim",
    optional = true,
    specs = {
      {
        [1] = "mrjones2014/codesettings.nvim",
        lazy = false,
        opts = function()
          -- https://github.com/mrjones2014/codesettings.nvim
          vim.lsp.config("*", {
            before_init = function(_, config)
              local codesettings = require("codesettings")
              codesettings.with_local_settings(config.name, config)
            end,
          })
        end,
      },
    },
  },
}
