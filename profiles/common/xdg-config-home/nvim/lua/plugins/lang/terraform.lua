--[[
  NOTE:
    Enable `lang.terraform` from LazyExtra
--]]

---@type LazySpec[]
return {
  {
    [1] = "nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      --[[
      -- HACK: 아래 이슈가 해결되기전까지 semanticTokensProvider 는 끔  <2026-05-05>

      1. LazyVim의 Terraform extra가 .tf 파일에 terraformls를 붙입니다.
      2. Neovim이 semantic tokens 기능을 지원한다고 알립니다.
      3. terraform-ls가 syntax highlighting용 semantic token 배열을 보냅니다.
      4. 그 배열 안에 비정상적인 deltaStart가 들어옵니다.
      5. Neovim 0.12.1 쪽 semantic highlighting 처리 루프가 그 값을 처리하다가 CPU 99%로 붙은 것으로 보입니다.
    --]]
      opts.servers = opts.servers or {}
      opts.servers.terraformls = opts.servers.terraformls or {}

      local old_on_attach = opts.servers.terraformls.on_attach

      opts.servers.terraformls.on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil

        if old_on_attach then
          return old_on_attach(client, bufnr)
        end
      end
    end,
  },
}
