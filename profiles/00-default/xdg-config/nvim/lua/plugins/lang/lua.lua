-- TODO: stylua 가 가끔 indent-type 을 tabs 로 지정해버리는데 이유가 뭔지 해결 <2025-06-08>
---@type LazySpec[]
return {
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = {
          "stylua",
          -- lsp_format = "never"
        },
      },
    },
  },
  {
    [1] = "nvim-lint",
    optional = true,
    opts = function(_, opts)
      -- nvim 이 실행된 cwd 에 selene.toml 가 포함된 repo 일때만 실행
      local cwd = vim.uv.cwd()
      local project_root = cwd ~= nil and vim.fs.root(cwd, { "selene.toml" }) or nil
      if project_root == nil then
        return
      end

      local lint = require("lint")
      lint.linters.selene.cwd = project_root

      opts.linters_by_ft = vim.tbl_extend("error", opts.linters_by_ft or {}, {
        lua = { "selene" },
      })

      opts.linters = opts.linters or {}
      opts.linters.selene = vim.tbl_extend("error", opts.linters.selene or {}, {
        -- `condition` is another LazyVim extension that allows you to
        -- dynamically enable/disable linters based on the context.
        condition = function(ctx)
          -- NOTE: ctx.filename 은 absolute path 임
          return vim.startswith(ctx.filename, project_root)
        end,
      })

      return opts
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
      local nls = require("null-ls")

      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.selene.with({
          condition = function(utils)
            return utils.root_has_file({ "selene.toml" })
          end,
        }),
      })

      return opts
    end,
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "selene" } },
      },
    },
  },
}
