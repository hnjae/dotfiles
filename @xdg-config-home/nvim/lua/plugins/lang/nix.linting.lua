---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  opts = function(_, opts)
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.nix = opts.linters_by_ft.nix or {}

    local linters = {
      "statix",
      "deadnix",
    }

    for _, linter in ipairs(linters) do
      if vim.fn.executable("linter") then
        table.insert(opts.linters_by_ft.nix, linter)
      end
    end

    return opts
  end,
  specs = {
    -- NOTE: 제공 안함 <2025-04-09>
    --[[ {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = {} },
    }, ]]
  },
}
