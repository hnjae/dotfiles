-- NOTE: 파일 경로에 대괄호 들었을 경우, 에러 로그 송출  <2025-08-02>
---@type LazySpec
return {
  [1] = "neoconf.nvim",
  optional = true,
  -- enabled = true,
  opts = {
    global_settings = "neoconf.jsonc",
    import = {
      -- vscode = false, -- local .vscode/settings.json
      -- coc = false, -- global/local coc-settings.json
      -- nlsp = false, -- global/local nlsp-settings.nvim json settings
    },
  },
}
