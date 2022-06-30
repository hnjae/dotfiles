local status_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
local status_lspconfig , lspconfig = pcall(require, "lspconfig")


if not status_lsp_installer or not status_lspconfig then
  local M = {}
  M.setup = function() end
  return M
end

local M = {}

local is_lsp_active = function(lsp)
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return false
    end

    for _, client in ipairs(clients) do
      if client.name == lsp then
        return true
      end
    end

  return false
end

M.setup = function (lsps, path)
  lsp_installer.setup {
    ensure_installed = lsps
  }
  require("user.lsp.set-commands").setup()


  for _, lsp in pairs(lsps) do
    if is_lsp_active(lsp) then
      goto continue
    end

    local opts = {
      on_attach = require("user.lsp.handlers").on_attach,
      capabilities = require("user.lsp.handlers").capabilities,
    }
    local has_custom_opts, get_lsp_custom_opts = pcall(require, "user.lsp.settings." .. lsp)
    if has_custom_opts then
      opts = vim.tbl_deep_extend("force", get_lsp_custom_opts(path), opts)
    end


    lspconfig[lsp].setup(opts)

    ::continue::
  end
end

----------------------------------------------
-- "sourcery",
-- "pylsp",
-- "pylsp"
-- local servers = { "jsonls", "sumneko_lua",  }
-- lsp_installer.setup {
--   ensure_installed = servers
-- }
----------------------------------------------
----------------------------------------------
-- require("user.lsp.commands")

----------------------------------------------
-- for _, server in pairs(servers) do
--   local opts = {
--     on_attach = require("user.lsp.handlers").on_attach,
--     capabilities = require("user.lsp.handlers").capabilities,
--   }
--   local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
--   if has_custom_opts then
--     opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
--   end
--   lspconfig[server].setup(opts)
-- end

return M
