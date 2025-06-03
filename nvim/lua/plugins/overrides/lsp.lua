---@type LazySpec
return {
  [1] = "nvim-lspconfig",
  optional = true,
  opts = {
    -- options for vim.diagnostic.config()
    diagnostics = {
      virtual_lines = true, -- neovim 0.11
      virtual_text = false, -- 라인 끝에 표시되는 메시지 끄기.
    },
  },
}
