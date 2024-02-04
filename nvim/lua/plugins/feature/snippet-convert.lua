-- NOTE: snippet-converter does not support jsonc file type <2024-02-03>

---@type LazySpec
return {
  [1] = "smjonas/snippet-converter.nvim",
  enabled = false,
  config = function(_, _)
    local t1 = {
      name = "from_vscode_to_ultisnips",
      sources = {
        vscode_luasnip = {
          "path",
        },
      },
      output = {
        ultisnips = {
          "path",
        },
      },
    }
    -- code
    require("snippet_converter").setup({
      templates = {
        t1,
      },
    })
  end,
  opts = {},
}
