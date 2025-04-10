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
      "sh",
      "c",
      "cpp",
      "cs",
      "css",
      "elixir",
      "go",
      "haskell",
      "html",
      "java",
      "javascript",
      "javascriptreact",
      "kotlin",
      "lua",
      "php",
      "python",
      "ruby",
      "rust",
      "scala",
      "swift",
      "typescript",
      "typescriptreact",
      "yaml",
    }
    -- or use vim.tbl_contains(require("lspconfig.configs.ast_grep").default_config, vim.bo.filetype)

    -- based on LazyVim v14.14.0
    local key = {
      [1] = "<leader>se",
      [2] = function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        -- based-on LazyVim's <leader>sr implementation
        grug.open({
          transient = true,
          engine = "astgrep",
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      ft = astgrep_fts,
      desc = "astgrep (grug-far)",
    }

    local key_not_supported_fts = vim.deepcopy(key)
    key_not_supported_fts.ft = nil
    key_not_supported_fts[2] = function()
      local msg = string.format(
        "astgrep is not supported for: %s\n",
        vim.bo.filetype ~= "" and vim.bo.filetype or "<unknown filetype>"
      )
      local link_msg = "Check <https://ast-grep.github.io/reference/languages.html>"

      vim.notify(msg .. link_msg)
    end
    key_not_supported_fts.desc = "(NOT SUPPORTED) astgrep"

    return vim.list_extend(keys or {}, {
      key_not_supported_fts,
      key,
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
