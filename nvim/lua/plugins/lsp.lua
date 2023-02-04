-- lsp

local null_ls_spec = {
  "jose-elias-alvarez/null-ls.nvim",
  lazy = false,
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "williamboman/mason.nvim",
  },
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/CONFIG.md
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      diagnostics_format = "#{m} (#{s})",
      -- diagnostics_format = "[#{c}] #{m} (#{s})",
      sources = {
        -- null_ls.builtins.completion.spell,
        -- null_ls.builtins.completion.tags,
        -- null_ls.builtins.diagnostics.cspell,
        -- null_ls.builtins.diagnostics.eslint,
        -- null_ls.builtins.code_actions.cspell,

        -- kotlin
        null_ls.builtins.formatting.ktlint,
        null_ls.builtins.diagnostics.ktlint,

        -- "sh"
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.hover.printenv,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.dotenv_linter,
        -- null_ls.builtins.formatting.shellharden,

        -- zsh
        null_ls.builtins.diagnostics.zsh,
        null_ls.builtins.formatting.beautysh.with({ filetypes = { "zsh" } }),

        -- sqlfluff
        null_ls.builtins.diagnostics.sqlfluff,
        null_ls.builtins.formatting.sqlfluff,

        -- lua
        null_ls.builtins.diagnostics.selene.with({
          -- condition = function(utils)
          --   return utils.root_has_file({ "selene.toml" })
          -- end,
        }),
        null_ls.builtins.formatting.stylua,

        -- python
        null_ls.builtins.formatting.ruff, -- sort imports
        null_ls.builtins.formatting.black, -- format code
        null_ls.builtins.diagnostics.mypy.with({
          diagnostics_format = "[#{s}] #{m}",
        }),
        null_ls.builtins.diagnostics.ruff.with({
          diagnostics_postprocess = function(diagnostic)
            diagnostic.message = "["
              .. diagnostic.code
              .. "] "
              .. diagnostic.message
              .. " ("
              .. diagnostic.source
              .. ")"
            local severity = diagnostic.severity
            if diagnostic.code == "E902" or diagnostic.code == "E999" then
              severity = vim.diagnostic.severity.ERROR
            else
              severity = vim.diagnostic.severity.WARN
              -- -- TODO: this is dirty <2023-01-27, Hyunjae Kim>
              -- local code_1 = diagnostic.code:sub(1, 1)
              -- if code_1 == "I" or code_1 == "Q" or diagnostic.code:sub(1, 3) == "COM" then
              --   severity = vim.diagnostic.severity.HINT
              -- else
              -- end
            end
            diagnostic.severity = severity
          end,
        }),
      },
      root_dir = require("null-ls.utils").root_pattern(
        ".neoconf.json",
        ".editorconfig",
        "pyproject.toml",
        "vim.toml",
        "selene.toml",
        ".nlsp-settings",
        ".git"
      ),
    })
  end,
}

local lspconfig_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neodev.nvim",
    "tamago324/nlsp-settings.nvim",
    "williamboman/mason-lspconfig",
    {
      -- shows popup window about parameter/func
      -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
      "ray-x/lsp_signature.nvim",
      lazy = true,
      module = true,
    },
  },
}
lspconfig_spec.config = function()
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
end

return {
  lspconfig_spec,
  null_ls_spec,
  {
    "folke/neodev.nvim",
    lazy = true,
    opts = {},
  },
  {
    "tamago324/nlsp-settings.nvim",
    dependencies = {
      "rcarriga/nvim-notify",
      "folke/neodev.nvim",
    },
    config = function()
      local nlspsettings = require("nlspsettings")
      nlspsettings.setup({
        config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
        local_settings_dir = ".nlsp-settings",
        local_settings_root_markers_fallback = { ".git" },
        append_default_schemas = false,
        loader = "yaml",
      })
      -- use LspSettings instead
      vim.api.nvim_del_user_command("NlspConfig")
      vim.api.nvim_del_user_command("NlspBufConfig")
      vim.api.nvim_del_user_command("NlspLocalConfig")
      vim.api.nvim_del_user_command("NlspLocalBufConfig")
      vim.api.nvim_del_user_command("NlspUpdateSettings")
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "rust_analyzer",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    opts = {},
  },
  --
  {
    -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
    "folke/trouble.nvim",
    lazy = true,
    -- event = {},
    enabled = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "williamboman/mason.nvim",
    },
  },
  -- https://github.com/folke/lsp-colors.nvim
}
