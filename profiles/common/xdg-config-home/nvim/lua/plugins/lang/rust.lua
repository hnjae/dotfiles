--[[
  NOTE:
    Enable `lang.rust` from LazyExtra
--]]

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
          -- .vscode/settings.json 을 읽어들임.
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
