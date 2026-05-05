local function add_gitcommit_linter(opts, linter)
  opts.linters_by_ft = opts.linters_by_ft or {}
  opts.linters_by_ft.gitcommit = opts.linters_by_ft.gitcommit or {}

  if not vim.tbl_contains(opts.linters_by_ft.gitcommit, linter) then
    table.insert(opts.linters_by_ft.gitcommit, linter)
  end
end

local function git_root(filename)
  local dirname = vim.fn.fnamemodify(filename, ":p:h")
  local git_dir = vim.fs.find(".git", { path = dirname, upward = true })[1]

  return git_dir ~= nil and vim.fs.dirname(git_dir) or nil
end

local function current_git_root()
  return git_root(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
end

local function cocogitto_parser(output)
  if output == nil or vim.trim(output) == "" then
    return {}
  end

  local message = output:match("Error:%s*([^\r\n]+)")
  if message == nil then
    return {}
  end

  local expected = output:match("\n%s*=%s*([^\r\n]+)")
  if expected ~= nil then
    message = ("%s: %s"):format(message, expected)
  end

  local lnum, col = output:match("%-%->%s*(%d+):(%d+)")

  return {
    {
      source = "cocogitto",
      lnum = math.max((tonumber(lnum) or 1) - 1, 0),
      col = math.max((tonumber(col) or 1) - 1, 0),
      severity = vim.diagnostic.severity.ERROR,
      message = message,
    },
  }
end

local function current_commit_message()
  return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, true), "\n")
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

      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.gitcommit = opts.linters_by_ft.gitcommit or {}

      if not vim.tbl_contains(opts.linters_by_ft.gitcommit, "gitlint") then
        table.insert(opts.linters_by_ft.gitcommit, "gitlint")
      end

      return opts
    end,
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "gitlint" } },
      },
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

      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.gitcommit = opts.linters_by_ft.gitcommit or {}

      if not vim.tbl_contains(opts.linters_by_ft.gitcommit, "commitlint") then
        table.insert(opts.linters_by_ft.gitcommit, "commitlint")
      end

      return opts
    end,
    specs = {},
  },
  {
    --[[
      NOTE:
        - Lint commit messages
        - <https://docs.cocogitto.io/guide/verify.html>
    --]]
    [1] = "nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      opts.linters.cocogitto = vim.tbl_extend("force", opts.linters.cocogitto or {}, {
        cmd = "cog",
        append_fname = false,
        args = {
          "verify",
          current_commit_message,
        },
        stream = "stderr",
        ignore_exitcode = true,
        parser = cocogitto_parser,
        condition = function(ctx)
          return vim.fn.executable("cog") == 1 and git_root(ctx.filename) ~= nil
        end,
      })

      add_gitcommit_linter(opts, "cocogitto")

      return opts
    end,
    specs = {},
  },
}
