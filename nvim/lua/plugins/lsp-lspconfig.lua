return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neodev.nvim",
    "tamago324/nlsp-settings.nvim",
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = true,
      dependencies = {
        "williamboman/mason.nvim", -- mason should been setuped before mason-lspconfig
      },
      opts = {
        ensure_installed = {
          "rust_analyzer",
        },
      },
    },
    {
      -- shows popup window about parameter/func
      -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
      "ray-x/lsp_signature.nvim",
      lazy = true,
      module = true,
    },
  },
  config = function()
    local lspconfig = require("lspconfig")

    -------------------------------------
    -- on_attach
    -------------------------------------
    local on_attach = function(client, bufnr)
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

      require("lsp_signature").on_attach()
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

    for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
      lspconfig[server].setup({
        on_attach = on_attach,
        -- https://www.reddit.com/r/neovim/comments/syjqdp/lua_lsp_unpack_is_shown_as_deprecated/
        root_dir = lspconfig.util.root_pattern(
          ".neoconf.json",
          ".editorconfig",
          "pyproject.toml",
          "vim.toml",
          "selene.toml",
          ".nlsp-settings",
          ".git"
        ),
      })
    end
  end,
}
