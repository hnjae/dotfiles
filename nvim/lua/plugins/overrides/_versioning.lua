--[[
  LazyVim 이 관리하는 플러그인 중, 버전 업데이트로 LazyVim 과 같이 동작하지 않는 플러그인.
--]]

---@type LazySpec
return {
  [1] = "LazyVim",
  optional = true,
  opts = {},
  specs = {
    {
      -- https://github.com/mason-org/mason-lspconfig.nvim/releases
      -- 14.14.0 에서 충돌 2025-05-07T09:29:03+09:00
      [1] = "mason-lspconfig.nvim",
      optional = true,
      version = "1.*",
    },
    {
      [1] = "mason.nvim",
      optional = true,
      version = "1.*",
    },
  },
}
