local status_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
local status_lspconfig, lspconfig = pcall(require, "lspconfig")
local status_nlspsettings, nlspsettings = pcall(require, "nlspsettings")

local M = {}

if not status_lsp_installer or not status_lspconfig then
  M.setup = function() end
  return M
end

-- if status_nlspsettings then
--   nlspsettings.setup({
--       -- config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
--       -- local_settings_dir = ".nlsp-settings",
--       -- local_settings_root_markers = { '.git' },
--       loader = 'json',
--       -- open_strictly = false, -- default: false
--       append_default_schemas = true,
--       nvim_notify = { enable= true, timeout = 1000 },
--   })
-- end

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

M.setup = function(lsps, path)
  lsp_installer.setup {
    ensure_installed = lsps
  }

  for _, lsp in pairs(lsps) do
    if is_lsp_active(lsp) then
      goto continue
    end

    local opts = {
      on_attach = require("user.lsp.handlers").on_attach,
      capabilities = require("user.lsp.handlers").capabilities,
      -- on_init = require("user.lsp.handlers").on_init,
    }

    ----------------------------------------------------------------------------
    -- config using user.lsp.settings.
    -- I'll migrate to nlsp-settings. (2022-07-02)
    local has_settings, lsp_settings = pcall(require, "user.lsp.settings." .. lsp)
    if has_settings then
      opts = vim.tbl_deep_extend("force", lsp_settings.opts, opts)
    end
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- opts = vim.tbl_extend("force", lspconfig.util.default_config, opts)
    -- config using nlspsettings
    -- lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    --   capabilities = opts.capabilities,
    -- })

    -- lsp_installer.on_server_ready(function(server)
    --   server:setup({
    --     on_attach = opts.on_attach
    --   })
    -- end)
    --------------------------------------------------------------------------
    lspconfig[lsp].setup(opts)


    ::continue::
  end

end

----------------------------------------------
-- "sourcery",
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
