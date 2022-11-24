-- :help base-directory
local status_ok, jdtls = pcall(require, "jdtls")

if not status_ok then
  return
end

-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew'}),
-- local workspace_dir = vim.fn.resolve(vim.fn.stdpath('data') .. '/jdtls/' .. project_name)
local workspace_dir = vim.fn.expand('~/.cache/jdtls-workspace/') .. project_name

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    -- 💀
    'java',

    	---Declipse.application=org.eclipse.jdt.ls.core.id1 \
	---Dosgi.bundles.defaultStartLevel=4 \
	---Declipse.product=org.eclipse.jdt.ls.core.product \
	---Dlog.level=ALL \
	---noverify \
	---Xmx1G \
	----add-modules=ALL-SYSTEM \
	----add-opens java.base/java.util=ALL-UNNAMED \
	----add-opens java.base/java.lang=ALL-UNNAMED \
	---jar ./plugins/org.eclipse.equinox.launcher_1.5.200.v20180922-1751.jar \
	---configuration ./config_linux \
	---data /path/to/data

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.level=ALL',
    '-noverify',
    '-Xmx1G',
    -- '--add-modules=ALL-SYSTEM',
    -- '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    -- '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    '-jar', '/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',

    -- 💀
    '-configuration', '/home/hyunjae/.local/share/java/jdtls/config_linux',

    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_dir,
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  -- settings = {
  --   java = {
  --   }
  -- },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  -- init_options = {
  --   bundles = {}
  -- },

  capabilities = require('user.lsp.handlers').capabilities,
  on_attach = require('user.lsp.handlers').on_attach
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
