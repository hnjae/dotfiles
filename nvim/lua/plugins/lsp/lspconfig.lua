local val = require("val")

---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    "folke/neodev.nvim",
    "tamago324/nlsp-settings.nvim",

    {
      -- shows popup window about parameter/func
      -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
      -- use folkey/noice.nvim instead
      [1] = "ray-x/lsp_signature.nvim",
      lazy = true,
      opts = {},
      module = false,
      enabled = false,
    },
  },
  config = function()
    local lspconfig = require("lspconfig")

    -------------------------------------
    -- capabilities
    -------------------------------------
    local global_capabilities = vim.lsp.protocol.make_client_capabilities()
    global_capabilities.textDocument.completion.completionItem.snippetSupport = true
    local status_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_cmp_nvim_lsp then
      -- capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
      global_capabilities = vim.tbl_extend("keep", global_capabilities or {}, cmp_nvim_lsp.default_capabilities())
    end

    -------------------------------------
    --
    -------------------------------------
    lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
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

    local paths =
        vim.fn.uniq(vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), "lua/plugins/lsp/lang/*.lua", false, true)))

    local lang_conf
    for _, file in pairs(paths) do
      lang_conf = require("plugins.lsp.lang." .. file:match("[^/\\]+$"):sub(1, -5))
      if lang_conf.setup_lspconfig then
        lang_conf.setup_lspconfig(lspconfig, opts)
      end
    end
  end,
}
