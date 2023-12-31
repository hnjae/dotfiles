local val = require("val")

return {
  {
    [1] = "williamboman/mason-lspconfig.nvim",
    lazy = true,
    enabled = function()
      if vim.fn.has("unix") == 1 then
        -- NOTE: use system package manager instead <2023-11-24>
        return false
      end

      local ensure_bins = {
        "unzip",
        "git",
      }

      local ret = true
      local msg
      for _, bin in pairs(ensure_bins) do
        if vim.fn.executable(bin) ~= 1 then
          msg = "mason-lspconfig.nvim: " .. bin .. " is not installed."
          vim.notify(msg, vim.log.levels.WARN)
          ret = false
        end
      end

      return ret
    end,
    dependencies = {
      -- mason should been setuped before mason-lspconfig
      "williamboman/mason.nvim",
    },
    opts = function(_, opts)
      if vim.fn.has("unix") == 1 then
        return {}
      end

      opts.ensure_installed = {
        "rust_analyzer",
        "jedi_language_server",
        "lua_ls",
        "kotlin_language_server",
        "jsonls",
        "yamlls",
        "clangd",
        "rnix",
      }

      return opts
    end,
  },

  {
    [1] = "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      "tamago324/nlsp-settings.nvim",
      {
        -- shows popup window about parameter/func
        -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
        [1] = "ray-x/lsp_signature.nvim",
        lazy = true,
        module = false,
        opts = {},
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
  },
}
