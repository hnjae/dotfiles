local package_path = (...)
local M = {}

-- Type Effort (colemak-dh):
-- 1.0 tn
-- 1.1 se
-- 1.3 ri
-- 1.6 ~ 1.8 aodh
-- 2.0 ~ 2.2 yflvk
-- 2.3 ~ 2.4 bycu,
-- 2.5~ 2.7 wbx.
-- 2.9 gm
-- 3.0 + l
-- 3+ bq;/j

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
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  require(package_path .. ".lsp-keymap-setup")()
end

M.icons = require(package_path .. ".icons")

return M
