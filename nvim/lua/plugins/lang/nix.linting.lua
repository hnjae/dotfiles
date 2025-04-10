---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      nix = { "statix", "deadnix" },
    },
  },
  specs = {
    -- NOTE: 제공 안함 <2025-04-09>
    --[[ {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = {} },
    }, ]]
  },
}
