---@type LazySpec
return {
  [1] = "grug-far.nvim",
  optional = true,
  ---@type GrugFarOptionsOverride
  opts = {
    -- Must be one of 'ripgrep' | 'astgrep' | 'astgrep-rules' | nil
    engine = "ripgrep",
  },
  keys = function(_, keys)
    -- https://ast-grep.github.io/reference/languages.html
    -- last update: 2025-04-09
    local astgrep_fts = {
      sh = true,
      c = true,
      cpp = true,
      cs = true,
      css = true,
      elixir = true,
      go = true,
      haskell = true,
      html = true,
      java = true,
      javascript = true,
      javascriptreact = true,
      kotlin = true,
      lua = true,
      php = true,
      python = true,
      ruby = true,
      rust = true,
      scala = true,
      swift = true,
      typescript = true,
      typescriptreact = true,
      yaml = true,
    }
    -- or use vim.tbl_contains(require("lspconfig.configs.ast_grep").default_config, vim.bo.filetype)

    return vim.list_extend(keys or {}, {
      -- based on LazyVim v14.14.0
      {
        [1] = "<leader>se",
        [2] = function()
          if not astgrep_fts[vim.bo.filetype] then
            vim.notify(
              string.format(
                "astgrep is not supported for: %s\nCheck <https://ast-grep.github.io/reference/languages.html>",
                vim.bo.filetype
              )
            )
            return
          end

          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          -- based-on LazyVim's <leader>sr implementation
          grug.open({
            transient = true,
            engine = astgrep_fts[vim.bo.filetype] and "astgrep" or nil,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "astgerp (grug-far",
      },
    })
  end,
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "grug-far.nvim" },
      },
    },
    {
      -- provide binary
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "ast-grep" } },
    },
  },
}
