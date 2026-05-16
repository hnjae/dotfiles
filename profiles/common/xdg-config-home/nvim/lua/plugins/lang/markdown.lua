--[[
  NOTE:
    - DISABLE `lang.markdown` from LazyExtra
    - rumdl 이 lsp 로서 동작함. <2026-05-10>
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
      },
      formatters_by_ft = {
        ["markdown"] = { "LSP", "markdown-toc" },
        ["markdown.mdx"] = { "LSP", "markdown-toc" },
      },
    },
  },
  {
    "nvim-lspconfig",
    optional = true,
    -- ---@type lspconfig.options
    opts = {
      servers = {
        -- NOTE: rumdl 사용. <2026-05-10>
        marksman = {
          enabled = false,
        },
        tailwindcss = {
          enabled = false,
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
