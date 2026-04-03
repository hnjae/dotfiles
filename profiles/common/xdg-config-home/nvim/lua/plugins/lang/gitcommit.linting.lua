---@type LazySpec
return {
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
    table.insert(opts.linters_by_ft.gitcommit, "commitlint")

    return opts
  end,
  specs = {},
}
