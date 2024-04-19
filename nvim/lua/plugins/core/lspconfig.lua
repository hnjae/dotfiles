local val = require("val")

---@type LazySpec[]
return {
  {
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
            vim.tbl_deep_extend(
              "keep",
              server_opts.settings,
              server_global_opts
            )
          )
        end
      end
    end,
  },
  {
    [1] = "nvim-lualine/lualine.nvim",
    optional = true,
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

          if
            #names > num_source_semi_limit
            and (#names - num_source_semi_limit) > 1
          then
            return string.format(
              "%s%s +[%s]",
              lsp_icon,
              table.concat({ unpack(names, 1, num_source_semi_limit) }, ", "),
              #names - num_source_semi_limit
            )
          end

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
}
