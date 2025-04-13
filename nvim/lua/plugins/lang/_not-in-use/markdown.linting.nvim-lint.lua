---@type LazySpec[]
return {
  {
    [1] = "nvim-lint",
    optional = true,
    opts = function(_, opts)
      local root_pattern = require("lspconfig").util.root_pattern(
        ".markdownlint-cli2.jsonc",
        ".markdownlint-cli2.yaml",
        ".markdownlint-cli2.cjs",
        ".markdownlint-cli2.mjs",
        ".markdownlint.jsonc",
        ".markdownlint.json",
        ".markdownlint.yaml",
        ".markdownlint.yml",
        ".markdownlint.cjs",
        ".markdownlint.mjs"
      )

      ---@type string | nil
      local cwd = vim.api.nvim_buf_get_name(0)
      if cwd == "" then
        cwd = vim.uv.cwd()
      end

      if cwd ~= nil then
        opts.linters = opts.linters or {}
        opts.linters["markdownlint-cli2"] = vim.tbl_deep_extend("keep", opts.linters["markdownlint-cli2"] or {}, {
          cwd = root_pattern(cwd),
        })
      end
    end,
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "selene" } },
      },
    },
  },
  {
    [1] = "none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sources = vim.tbl_filter(function(source)
        return source.name ~= "markdownlint-cli2"
      end, opts.sources or {})
    end,
  },
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          condition = function(_, _)
            return true
          end,
        },
      },
    },
  },
}
