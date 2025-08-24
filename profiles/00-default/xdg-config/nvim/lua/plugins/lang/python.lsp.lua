---@type LazySpec[]
return {
  {
    [1] = "nvim-lspconfig",
    optional = true,
    -- ---@type lspconfig.options
    opts = {
      servers = {
        basedpyright = {
          mason = false, -- mason 이 venv 안에 설치하는데, 이것이 이슈가 있음. <2025-05-07>
        },
      },
    },
  },
}
