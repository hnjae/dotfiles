local val = require("val")

-- :help lsp-defaults

---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  lazy = true,
  -- event = { "VeryLazy" },
  enabled = true,
  event = { "BufRead", "BufNewFile" },
  keys = {
    -- nvim's default mapping:
    -- { [1] = "K", [2] = vim.lsp.buf.hover, desc = "lsp-hover" },
  },
  dependencies = {},
  ---@class myLspconfigOpts
  opts = {
    ---@type LspconfigSetupOptsSpec
    servers = {
      -- lua_ls = {
      --   settings = {},
      -- },
    },
    ---@type { [string]: function }
    setup = {
      -- Specify * to use this function as a fallback for any server
      ["*"] = function(server, opts)
        require("lspconfig")[server].setup(opts)
      end,
    },
    -- `runtime/lua/vim/lsp/_meta/protocol.lua`
    ---@type lsp.ClientCapabilities
    default_capabilities = {},
  },
  ---@param opts myLspconfigOpts
  config = function(_, opts)
    local lspconfig = require("lspconfig")
    local prefix = require("val.prefix")
    local map_keyword = require("val.map-keyword")

    -------------------------------------
    -- capabilities
    -------------------------------------
    lspconfig.util.default_config =
      vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          opts.default_capabilities
        ),
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

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        -- NOTE: https://neovim.io/doc/user/lsp.html#lsp-api
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          return
        end

        vim.keymap.set("n", prefix.close .. map_keyword.lsp, function()
          for _, buf_client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            buf_client.stop()
          end
        end, { desc = "stop-lsp", buffer = args.buf })

        local keymap_opts = { buffer = args.buf }
        local local_prefix = "<LocalLeader>" .. map_keyword.lsp
        local mappings = {
          ["_"] = {
            {
              lhs_suffix = "I",
              rhs = "<cmd>LspInfo<CR>",
              desc = "lsp-info",
            },
          },
          ["callHierarchy/incomingCalls"] = {
            lhs_suffix = "i",
            rhs = vim.lsp.buf.incoming_calls,
            desc = "incoming-calls",
          },
          ["callHierarchy/outgoingCalls"] = {
            lhs_suffix = "o",
            rhs = vim.lsp.buf.outgoing_calls,
            desc = "outgoing-calls",
          },
          ["textDocument/codeAction"] = {
            {
              lhs_suffix = map_keyword.execute,
              rhs = vim.lsp.buf.code_action,
              desc = "code-action",
            },
            {
              lhs_suffix = map_keyword.execute,
              -- NOTE: vim 9.0 부터 function() 으로 랩핑 해줘야 동작. <2022-?>
              rhs = function()
                vim.lsp.buf.range_code_action()
              end,
              desc = "range-code-action",
              mode = "x",
            },
          },
          -- ["textDocument/completion"] = {},
          ["textDocument/codeLens"] = {
            {
              mode = { "n", "v" },
              lhs_suffix = "s",
              rhs = vim.lsp.codelens.run,
              desc = "code-lens-run",
            },
            {
              lhs_suffix = "S",
              rhs = vim.lsp.codelens.refresh,
              desc = "code-lens-refresh",
            },
          },
          ["textDocument/declaration"] = {
            lhs_suffix = "D",
            rhs = vim.lsp.buf.declaration,
            desc = "open-declaration",
          },
          ["textDocument/definition"] = {
            lhs_suffix = "d",
            rhs = vim.lsp.buf.definition, -- opens definition in current window
            desc = "open-definition",
          },
          ["textDocument/documentHighlight"] = {
            lhs_suffix = "l",
            rhs = vim.lsp.buf.document_highlight,
            desc = "document-highlight",
          },
          -- ["textDocument/documentSymbol"] = { lhs_suffix = "y", rhs = vim.lsp.buf.document_symbol, desc = "document-symbol", }, -- telescope 으로 액세스
          -- ["textDocument/formatting"] = {}, -- use conform.nvim
          -- ["textDocument/hover"] = {}, -- neovim set this feature to K
          ["textDocument/implementation"] = {
            lhs_suffix = "m",
            rhs = vim.lsp.buf.implementation,
            desc = "open-implementation",
          },
          -- ["textDocument/inlayHint"] = {},
          ["textDocument/publishDiagnostic"] = {
            -- -- use lspsagaintsead
            -- {
            --   lhs = "[r",
            --   rhs = function()
            --     vim.diagnostic.goto_prev({
            --       severity = vim.diagnostic.severity["ERROR"],
            --     })
            --   end,
            --   desc = "prev-diagnostic-error",
            -- },
            -- {
            --   lhs = "]r",
            --   rhs = function()
            --     vim.diagnostic.goto_next({
            --       severity = vim.diagnostic.severity["ERROR"],
            --     })
            --   end,
            --   desc = "next-diagnostic-error",
            -- },
            -- {
            --   lhs = "[w",
            --   rhs = function()
            --     vim.diagnostic.goto_prev({
            --       severity = vim.diagnostic.severity["WARN"],
            --     })
            --   end,
            --   desc = "prev-diagnostic-warn",
            -- },
            -- {
            --   lhs = "]w",
            --   rhs = function()
            --     vim.diagnostic.goto_next({
            --       severity = vim.diagnostic.severity["WARN"],
            --     })
            --   end,
            --   desc = "next-diagnostic-warn",
            -- },
          },
          -- ["textDocument/prepareTypeHierarchy"] = {},
          -- ["textDocument/rangeFormatting"] = {},
          -- ["textDocument/rangesFormatting"] = {},
          ["textDocument/references"] = {
            lhs_suffix = "r",
            rhs = vim.lsp.buf.references,
            desc = "quickfix-references",
          },
          ["textDocument/rename"] = {
            lhs_suffix = "n",
            rhs = vim.lsp.buf.rename,
            desc = "rename",
          },
          -- ["textDocument/semanticTokens/full"] = {},
          -- ["textDocument/semanticTokens/full/delta"] = {},
          ["textDocument/signatureHelp"] = {
            lhs_suffix = "h",
            rhs = vim.lsp.buf.signature_help,
            desc = "signature-help",
          },
          ["textDocument/typeDefinition"] = {
            lhs_suffix = "p",
            rhs = vim.lsp.buf.type_definition,
            desc = "type-definition",
          },
          ["typeHierarchy/subtypes"] = {
            lhs_suffix = "t",
            rhs = function()
              vim.lsp.buf.typehierarchy("subtypes")
            end,
            desc = "typehierarchy-subtypes",
          },
          ["typeHierarchy/supertypes"] = {
            lhs_suffix = "T",
            rhs = function()
              vim.lsp.buf.typehierarchy("supertypes")
            end,
            desc = "typehierarchy-supertypes",
          },
          -- ["window/logMessage"] = {},
          -- ["window/showMessage"] = {},
          -- ["window/showDocument"] = { lhs_suffix = "ud", rhs = vim.lsp.util.show_document, desc = "show-document", },
          -- ["window/showMessageRequest"] = {},
          -- ["workspace/applyEdit"] = {},
          -- ["workspace/configuration"] = {},
          -- ["workspace/executeCommand"] = {},
          -- ["workspace/inlayHint/refresh"] = {},
          -- ["workspace/symbol"] = { lhs_suffix = "Y", rhs = vim.lsp.buf.workspace_symbol, desc = "workspace-symbol", }, -- treesitter 이용
          ["workspace/workspaceFolders"] = {
            {
              lhs_suffix = "wa",
              rhs = vim.lsp.buf.add_workspace_folder,
              desc = "add-workspace",
            },
            {
              lhs_suffix = "wr",
              rhs = function()
                vim.ui.select(
                  vim.lsp.buf.list_workspace_folders(),
                  { prompt = "vim.lsp.buf.list_workspace_folders()" },
                  function(choice)
                    if choice ~= nil then
                      vim.lsp.buf.remove_workspace_folder(choice)
                    end
                  end
                )
              end,
              desc = "remove-workspace",
            },
            {
              lhs_suffix = "wl",
              rhs = function()
                vim.ui.select(
                  vim.lsp.buf.list_workspace_folders(),
                  { prompt = "vim.lsp.buf.list_workspace_folders()" },
                  function(choice)
                    -- let @a = 'Hello, Neovim!'
                    vim.fn.setreg("@", choice)
                    vim.notify(
                      "Selected workspace has been assigned to the register."
                    )
                  end
                )
              end,
              desc = "list-workspace-folders",
            },
          },
        }
        for method, specs in pairs(mappings) do
          if method == "_" or client.supports_method(method) then
            for _, spec in ipairs(specs.rhs and { specs } or specs) do
              vim.keymap.set(
                spec.mode and spec.mode or "n",
                spec.lhs and spec.lhs or (local_prefix .. spec.lhs_suffix),
                spec.rhs,
                vim.tbl_extend("error", keymap_opts, { desc = spec.desc })
              )
            end
          end
        end
      end,
    })
  end,
  specs = {
    -- / (search) 에서 사용 용도 @ + typing
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      ---@param opts myCmpOpts
      opts = function(_, opts)
        opts.cmdline_search_sources = vim.list_extend(
          opts.cmdline_search_sources or {},
          require("cmp").config.sources({
            { name = "nvim_lsp_document_symbol" }, -- @+typing
          })
        )
      end,
    },
    {
      [1] = "hrsh7th/cmp-nvim-lsp",
      optional = true,
      specs = {
        {
          [1] = "hrsh7th/nvim-cmp",
          optional = true,
          dependencies = { "hrsh7th/cmp-nvim-lsp" },
          ---@param opts cmp.ConfigSchema
          opts = function(_, opts)
            local cmp = require("cmp")
            if not opts.sources then
              opts.sources = {}
            end
            vim.list_extend(
              opts.sources,
              cmp.config.sources({
                { name = "nvim_lsp", priority = 10 },
              })
            )
          end,
        },
        {
          [1] = "neovim/nvim-lspconfig",
          optional = true,
          ---@param opts myLspconfigOpts
          opts = function(_, opts)
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            opts.default_capabilities = cmp_nvim_lsp.default_capabilities() -- includes snippet support
          end,
        },
      },
    },
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      ---@param opts myLualineOpts
      opts = function(_, opts)
        local utils = require("utils")
        local hide_width = 40
        local truc_width = 100
        local num_source_semi_limit = 2
        local suppress_sources = {
          ["null-ls"] = true,
        }

        local lsp_icon = utils.enable_icon
            and (require("val").icons.codicons.gear .. " ")
          or "L "

        local lsp_name_fmt = function(name)
          return name:sub(-16, -1) == "_language_server"
              and name:sub(1, -17) .. "-ls"
            or (name:sub(-3, -1) == "_ls" and name:sub(1, -4) .. "-ls" or name)
        end

        local lsp_filter = function(name)
          if suppress_sources[name] then
            return false
          end

          return true
        end

        local component = {
          [1] = function()
            local lualine_width = require("val.plugins.lualine").options.globalstatus
                and vim.o.columns
              or vim.fn.winwidth(0)

            if lualine_width < hide_width then
              return ""
            end

            local clients = vim.lsp.get_active_clients({ bufnr = 0 })

            local names = {}
            ---@type boolean
            for _, client in ipairs(clients) do
              if lsp_filter(client.name) then
                table.insert(names, lsp_name_fmt(client.name))
              end
            end

            if next(names) == nil then
              return ""
              -- if vim.bo.buftype ~= "" or vim.bo.filetype == "text" then
              --   return ""
              -- end
              --
              -- return (
              --   require("utils").enable_icon and (lsp_icon .. "∅")
              --   or "No active LSP"
              -- )
            end

            if lualine_width < truc_width then
              return (string.format("%s[%s]", lsp_icon, #names))
            end

            -- if
            --   #names > num_source_semi_limit
            --   and (#names - num_source_semi_limit) > 1
            -- then
            --   return string.format(
            --     "%s%s +[%s]",
            --     lsp_icon,
            --     table.concat({ unpack(names, 1, num_source_semi_limit) }, ", "),
            --     #names - num_source_semi_limit
            --   )
            -- end

            return string.format("%s%s", lsp_icon, table.concat(names, ", "))
          end,
          cond = nil,
        }

        if not opts.sections then
          opts.sections = {}
        end
        if not opts.sections.lualine_x then
          opts.sections.lualine_x = {}
        end

        vim.list_extend(opts.sections.lualine_x, {
          {
            component = component,
            priority = 60,
          },
        })
      end,
    },
  },
}
