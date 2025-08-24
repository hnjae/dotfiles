---@type LazySpec[]
return {
  -- {
  --   --[[
  --   NOTE:
  --     markdown, text, rst, tex
  --   ---]]
  --   [1] = "neovim/nvim-lspconfig",
  --   optional = true,
  --   opts = {
  --     servers = {
  --       vale_ls = {
  --         enabled = true,
  --       },
  --     },
  --   },
  --   specs = {
  --     {
  --       [1] = "mason.nvim",
  --       optional = true,
  --       opts = { ensure_installed = { "vale-ls" } },
  --     },
  --   },
  -- },
  {
    --[[
    DOCS:
      - require config file (`.vale.ini`) in the root of the project
      - should run `vale sync` after updating `.vale.ini`

    NOTE:
      - A markup-aware linter for prose built with speed and extensibility in mind.
      - checks spelling, style
      - <https://github.com/errata-ai/vale>
      - text, markdown, asciidoc, org, rst, xml, html, tex (2025-04-09)
  --]]
    [1] = "nvim-lint",
    optional = true,
    opts = function(_, opts)
      if vim.fn.executable("vale") ~= 1 then
        return opts
      end

      local config_dir = require("lspconfig").util.root_pattern(".vale.ini")(vim.uv.cwd())

      if config_dir == nil then
        local global_config = vim.fn.expand("$XDG_CONFIG_HOME/vale/vale.ini")

        if vim.loop.fs_stat(global_config) == nil then
          return opts
        end

        local function get_cur_file_extension(bufnr)
          bufnr = bufnr or 0
          return "." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e")
        end

        local vale = require("lint").linters.vale
        vale.args = {
          "--no-exit",
          "--config",
          global_config,
          "--output",
          "JSON",
          "--ext",
          get_cur_file_extension,
        }
      end

      opts.linters_by_ft = opts.linters_by_ft or {}

      for _, ft in ipairs({ "text", "markdown", "rst", "tex", "asciidoc", "org", "xml", "html" }) do
        opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
        table.insert(opts.linters_by_ft[ft], "vale")
      end

      return opts
    end,
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "vale" } },
      },
    },
  },
}
