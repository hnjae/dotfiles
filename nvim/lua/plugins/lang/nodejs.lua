---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("tsx", "typescript", "javascript")
    end,
  },
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local formatter
      local formatters_by_ft

      -- if require("utils").lsp.is_prettier() then
      if
        (not require("utils").lsp.is_deno())
        and (
          vim.fn.executable("prettierd") == 1
          or vim.fn.executable("prettier") == 1
        )
      then
        formatter = { "prettierd", "prettier" }
        formatters_by_ft = {
          typescript = { formatter },
          javascript = { formatter },
          typescriptreact = { formatter },
          javascriptreact = { formatter },
          json = { formatter },
          jsonc = { formatter },

          html = { formatter },
          vue = { formatter },
          css = { formatter },
          scss = { formatter },
          lss = { formatter },
          graphql = { formatter },
          handlebars = { formatter },

          -- markdown = { formatter },
          -- yaml = { formatter },
          ["markdown.mdx"] = { formatter },
        }
      else
        -- use deno_fmt as fallback
        if not require("utils").lsp.is_deno() then
          -- if no deno.json (random javascript file)

          opts.formatters = opts.formatters or {}
          opts.formatters.deno_fmt = opts.formatters.deno_fmt or {}
          opts.formatters.deno_fmt.append_args = opts.formatters.deno_fmt.append_args
            or {}
          table.insert(opts.formatters.deno_fmt.append_args, "--single-quote")
        end

        formatter = { "deno_fmt" }

        formatters_by_ft = {
          typescript = { formatter },
          javascript = { formatter },
          typescriptreact = { formatter },
          javascriptreact = { formatter },
          json = { formatter },
          jsonc = { formatter },
          -- markdown = { formatter },
        }
      end

      if opts.formatters_by_ft == nil then
        opts.formatters_by_ft = {}
      end

      for key, val in pairs(formatters_by_ft) do
        opts.formatters_by_ft[key] = val
      end
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      if require("utils").lsp.is_deno() then
        return opts
      end

      if opts.servers == nil then
        opts.servers = {}
      end

      -- requires typescript-language-server
      opts.servers.tsserver = {
        ---@class LspconfigSetupOptsSpec
        settings = {
          commands = {
            OrganizeImports = {
              [1] = function()
                local params = {
                  command = "_typescript.organizeImports",
                  arguments = { vim.api.nvim_buf_get_name(0) },
                }
                vim.lsp.buf.execute_command(params)
              end,
              description = "Organize Imports",
            },
          },
        },
      }

      -- requires vscode-langservers-extracted
      opts.servers.eslint = {
        ---@class LspconfigSetupOptsSpec
        settings = {
          root_dir = require("lspconfig").util.root_pattern(unpack({
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "package.json",
          })),
        },
      }

      return opts
    end,
  },
}
