--[[
  README:
    - 설정 전역에 필요한 data 를 모아둡니다.
]]
local package_path = (...)

local M = {}

-- 설정 전역서 각종 키워드
M.map_keyword = require(package_path .. ".map-keyword")
M.prefix = require(package_path .. ".prefix")

M.root_patterns = require(package_path .. ".root-patterns")

---@type fun(client: table, bufnr: integer): nil
-- on_attach function for lspconfig and null-ls
M.on_attach = function(client, bufnr)
  -- if client.config.name ~= "null-ls" then
  --   -- require("messages.api").capture_thing(client.supports_method())
  --   require("messages.api").capture_thing(client)
  -- end
  --
  -- -- prefix.buffer .. map_keyword.lsp
  -- local capabilities = client.config.server_capabilities
  -- local prefix = M.prefix.buffer .. M.map_keyword.lsp
  -- for _, map in ipairs({ { "a", "code-action", "codeActionProvider" } }) do
  --   if capabilities[map[3]] then
  --     vim.keymap.set(
  --       "n",
  --       prefix .. map[1],
  --       vim.lsp.buf.code_action,
  --       { buffer = bufnr, desc = "lsp-" .. map[2] }
  --     )
  --   end
  -- end

  -- vim.notify(vim.inspect(client))

  -- 아래는 기본 동작으로 바뀜 i_CTRL-X_CTRL-O 로 사용
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

M.icons = require(package_path .. ".icons")

return M
