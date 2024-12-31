---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    init = function()
      require("state.treesitter-langs"):add("markdown")
    end,
  },
  {
    [1] = "preservim/tagbar",
    optional = true,
    ft = { "markdown" },
  },

  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        -- TODO: modifiable 이 off 일 때는 활성화 금지 <2023-12-28>
        marksman = {
          ---@class LspconfigSetupOptsSpec
          settings = {
            autostart = false,
          },
        },
      },
    },
  },

  {
    [1] = "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require("null-ls")

      local mapping = {
        -- english prose linter
        -- proselint = {
        --   null_ls.builtins.diagnostics.proselint.with({
        --     filetypes = { "markdown" },
        --     diagnostics_postprocess = function(diagnostic)
        --       diagnostic.severity = vim.diagnostic.severity.HINT
        --     end,
        --   }),
        -- },

        -- english prose linter
        -- wirte_good = {
        --   null_ls.builtins.diagnostics.write_good.with({
        --     filetypes = { "markdown" },
        --   }),
        -- },

        -- spelling, grammar
        -- textidote = {
        --   null_ls.builtins.diagnostics.textidote.with({
        --     filetypes = { "markdown" },
        --   }),
        -- },

        -- markdownlint = { null_ls.builtins.diagnostics.markdownlint },
      }

      for exe, sources in pairs(mapping) do
        if vim.fn.executable(exe) == 1 then
          vim.list_extend(opts.sources, sources)
        end
      end
    end,
  },
  {
    -- alternative: ellisonleao/glow.nvim
    [1] = "toppair/peek.nvim",
    ft = { "markdown" },
    enabled = vim.fn.executable("deno") == 1,
    cond = not require("utils").is_console,
    build = "deno task --quiet build:fast",
    opts = function()
      local ret = {}
      if vim.fn.has("linux") == 1 then
        if vim.fn.executable("chromium") == 1 then
          ret.app = "chromium"
        else
          vim.notify("peek.nvim: chromium not installed")
        end
      end
      return ret
    end,
    ---@type LazyKeysSpec[]
    keys = {
      {
        [1] = require("val").prefix.buffer .. "p",
        [2] = "<cmd>Preview<CR>",
        desc = "preview-using-peek",
        ft = "markdown",
      },
      {
        [1] = require("val").prefix.buffer .. "P",
        [2] = "<cmd>PreviewClose<CR>",
        desc = "preview-close",
        ft = "markdown",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "markdown" },
        callback = function()
          vim.api.nvim_buf_create_user_command(
            0,
            "Preview",
            require("peek").open,
            {}
          )
          vim.api.nvim_buf_create_user_command(
            0,
            "PreviewClose",
            require("peek").open,
            {}
          )
        end,
      })
    end,
  },
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local markdown_formatter = {}

      --[[
        NOTE:
        cbfmt: format codeblocks inside markdown
        mdsf: format markdown code blocks
      ]]

      if
        require("lspconfig.util").root_pattern(".cbfmt.toml")(vim.uv.cwd())
      then
        -- cbfmt 는 .cbfmt.toml 이 없을 경우 제대로 동작하지 않는다.
        table.insert(markdown_formatter, "cbfmt")
      end

      if require("utils").lsp.is_deno() then
        table.insert(markdown_formatter, "deno_fmt")
      -- elseif require("utils").lsp.is_prettier() then
      elseif vim.fn.executable("prettierd") == 1 then
        table.insert(markdown_formatter, "prettierd")
      elseif vim.fn.executable("prettier") == 1 then
        table.insert(markdown_formatter, "prettier")
        -- else
        -- markdownlint does not provides consist indent
        --   table.insert(markdown_formatter, "markdownlint")
        -- else
        -- mdformat force indentation to 2
        -- table.insert(markdown_formatter, "mdformat")
      end

      if opts.formatters_by_ft == nil then
        opts.formatters_by_ft = {}
      end

      opts.formatters_by_ft.markdown = markdown_formatter
    end,
  },
}
