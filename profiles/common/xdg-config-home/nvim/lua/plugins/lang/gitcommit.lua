local function add_gitcommit_linter(opts, linter)
  opts.linters_by_ft = opts.linters_by_ft or {}
  opts.linters_by_ft.gitcommit = opts.linters_by_ft.gitcommit or {}

  if not vim.tbl_contains(opts.linters_by_ft.gitcommit, linter) then
    table.insert(opts.linters_by_ft.gitcommit, linter)
  end
end

---@type LazySpec[]
return {
  {
    --[[
      NOTE:
        - Lint commit messages
        - <https://jorisroovers.com/gitlint/>
    --]]
    [1] = "nvim-lint",
    optional = true,
    opts = function(_, opts)
      local function git_root(filename)
        local dirname = vim.fn.fnamemodify(filename, ":p:h")
        local git_dir = vim.fs.find(".git", { path = dirname, upward = true })[1]

        return git_dir ~= nil and vim.fs.dirname(git_dir) or nil
      end

      local function current_git_root()
        return git_root(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
      end

      opts.linters = opts.linters or {}
      opts.linters.gitlint = vim.tbl_extend("force", opts.linters.gitlint or {}, {
        args = {
          "--staged",
          "--target",
          current_git_root,
          "--msg-filename",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
        condition = function(ctx)
          return vim.fn.executable("gitlint") == 1 and git_root(ctx.filename) ~= nil
        end,
      })

      add_gitcommit_linter(opts, "gitlint")

      return opts
    end,
    specs = {
      -- {
      --   [1] = "mason.nvim",
      --   optional = true,
      --   opts = { ensure_installed = { "gitlint" } },
      -- },
    },
  },
  {
    --[[
      NOTE:
        - Lint commit messages
        - <https://github.com/conventional-changelog/commitlint>
        - <https://commitlint.js.org>
    --]]
    [1] = "nvim-lint",
    optional = true,
    opts = function(_, opts)
      if vim.fn.executable("commitlint") ~= 1 then
        return opts
      end

      local config_dir = require("lspconfig").util.root_pattern({
        ".commitlintrc",
        ".commitlintrc.json",
        ".commitlintrc.yaml",
        ".commitlintrc.yml",
        ".commitlintrc.js",
        ".commitlintrc.cjs",
        ".commitlintrc.mjs",
        ".commitlintrc.ts",
        ".commitlintrc.cts",
        "commitlint.config.js",
        "commitlint.config.cjs",
        "commitlint.config.mjs",
        "commitlint.config.ts",
        "commitlint.config.cts",
      })(vim.uv.cwd())

      if config_dir == nil then
        return opts
      end

      add_gitcommit_linter(opts, "commitlint")

      return opts
    end,
    specs = {},
  },
}
