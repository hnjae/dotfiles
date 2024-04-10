local val = require("val")

---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  lazy = true,
  -- event = { "VeryLazy" },
  enabled = true,
  event = { "BufRead", "BufNewFile" },
  -- keys = {},
  dependencies = {},
  ---@class PluginLspOpts
  opts = {
    servers = {
      -- lua_ls = {
      --   settings = {},
      -- },
    },
    setup = {
      -- Specify * to use this function as a fallback for any server
      ["*"] = function(server, opts)
        require("lspconfig")[server].setup(opts)
      end,
    },
  },
  config = function(_, opts)
    local lspconfig = require("lspconfig")

    -------------------------------------
    -- capabilities
    -------------------------------------
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local status_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_cmp_nvim_lsp then
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        cmp_nvim_lsp.default_capabilities() -- includes snippet support
      )
    end

    lspconfig.util.default_config =
      vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = capabilities,
      })

    -------------------------------------
    -- server_opts
    -------------------------------------

    local server_global_opts = {
      on_attach = val.on_attach,
    }

    for server, server_opts in pairs(opts.servers) do
      local exe = lspconfig[server].document_config.default_config.cmd[1]
      if vim.fn.executable(exe) == 1 then
        local setup = (
          opts.setup[server] and opts.setup[server] or opts.setup["*"]
        )
        setup(
          server,
          vim.tbl_deep_extend("keep", server_opts.settings, server_global_opts)
        )
      end
    end
  end,
}
