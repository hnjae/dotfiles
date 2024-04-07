local val = require("val")

---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  lazy = true,
  -- event = { "VeryLazy" },
  enabled = true,
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    "folke/neodev.nvim",
    "folke/neoconf.nvim",
    {
      -- shows popup window about parameter/func
      -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
      -- can be replaced by noice (or partial cmp-nvim-lsp-signature-help)
      -- either does not open popup permanently while typing
      [1] = "ray-x/lsp_signature.nvim",
      lazy = true,
      opts = {
        -- fix_pos = false,
      },
      module = false,
      enabled = false,
    },
  },
  config = function()
    local lspconfig = require("lspconfig")

    -------------------------------------
    -- capabilities
    -------------------------------------
    -- local global_capabilities = {}

    local global_capabilities = vim.lsp.protocol.make_client_capabilities()
    local status_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_cmp_nvim_lsp then
      -- capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
      global_capabilities = vim.tbl_deep_extend(
        "force",
        global_capabilities,
        cmp_nvim_lsp.default_capabilities() -- includes snippet support
      )
    end

    -------------------------------------
    --
    -------------------------------------
    -- lspconfig.util.default_config.capabilities = global_capabilities

    lspconfig.util.default_config =
      vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = global_capabilities,
      })

    local opts = {
      on_attach = val.on_attach,
      -- https://www.reddit.com/r/neovim/comments/syjqdp/lua_lsp_unpack_is_shown_as_deprecated/
      -- root_dir = lspconfig.util.root_pattern(
      --   -- NOTE: unpack available from lua 5.1
      --   unpack(val.root_patterns)
      -- ),
    }

    -- local status_coq, coq = pcall(require, "coq")
    -- if status_coq then
    --   opts = coq.lsp_ensure_capabilities(opts)
    -- end

    local paths = vim.fn.uniq(
      vim.fn.sort(
        vim.fn.globpath(
          vim.fn.stdpath("config"),
          "lua/plugins/lsp/configs/*.lua",
          false,
          true
        )
      )
    )

    local lang_conf
    for _, file in pairs(paths) do
      lang_conf =
        require("plugins.lsp.configs." .. file:match("[^/\\]+$"):sub(1, -5))
      if lang_conf.setup_lspconfig then
        lang_conf.setup_lspconfig(lspconfig, opts)
      end
    end
  end,
}
