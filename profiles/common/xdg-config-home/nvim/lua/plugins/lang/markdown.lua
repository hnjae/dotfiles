--[[
  NOTE:
    Disable `lang.markdown` from LazyExtra
--]]

---@type LazySpec[]
return {
  {
    "mason.nvim",
    opts = { ensure_installed = { "rumdl" } },
  },
  {
    "conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["rumdl"] = {},
      },
      formatters_by_ft = {
        ["markdown"] = { "rumdl", "markdown-toc" },
        ["markdown.mdx"] = { "rumdl", "markdown-toc" },
      },
    },
  },
  {
    "nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_extend("force", opts.linters_by_ft or {}, {
        markdown = { "rumdl" },
      })

      LazyVim.on_load("nvim-lint", function()
        -- Post-process rumdl diagnostics so editor noise stays low while the
        -- formatter can still fix the underlying markdown.
        local lint = require("lint")
        local wrap = require("lint.util").wrap
        lint.linters.rumdl = wrap(lint.linters.rumdl, function(diagnostic)
          if diagnostic.source == "rumdl" then
            if diagnostic.code == "MD012" then -- MD012: no-multiple-blanks
              return nil
            end

            if diagnostic.severity == vim.diagnostic.severity.WARN then
              diagnostic.severity = vim.diagnostic.severity.INFO
            end
          end

          return diagnostic
        end)
      end)
    end,
  },
  {
    "nvim-lspconfig",
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
              if result and result.diagnostics then
                result.diagnostics = vim.tbl_filter(function(diagnostic)
                  return not tostring(diagnostic.code):match("^MD")
                end, result.diagnostics)
              end

              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
            end,
          },
        },
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
