return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neodev.nvim",
    "tamago324/nlsp-settings.nvim",
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = true,
      dependencies = {
        -- mason should been setuped before mason-lspconfig
        "williamboman/mason.nvim",
      },
      opts = {
        ensure_installed = {
          "rust_analyzer",
          "jedi_language_server",
          "lua_ls",
          "kotlin_language_server",
          "jsonls",
          "yamlls",
          "clangd",
        },
      },
    },
    {
      -- shows popup window about parameter/func
      -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
      "ray-x/lsp_signature.nvim",
      lazy = true,
      module = false,
      opts = {},
    },
  },
  config = function()
    local lspconfig = require("lspconfig")

    -------------------------------------
    -- on_attach
    -------------------------------------
    local on_attach = function(_, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      vim.keymap.set("n", "==", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "lsp-format", buffer = bufnr })

      vim.keymap.set("v", "==", function()
        vim.lsp.buf.format({
          async = true,
          range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
          },
        })
      end, { desc = "lsp-buf-format", buffer = bufnr })
    end

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
      on_attach = on_attach,
      -- https://www.reddit.com/r/neovim/comments/syjqdp/lua_lsp_unpack_is_shown_as_deprecated/
      root_dir = lspconfig.util.root_pattern(
        -- NOTE: unpack available on lua 5.1
        unpack(require("val").root_patterns)
      ),
    }
    local status_coq, coq = pcall(require, "coq")
    if status_coq  then
      opts = coq.lsp_ensure_capabilities(opts)
    end
    for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
      lspconfig[server].setup(opts)
    end
  end,
}
