-- function string:endswith(suffix)
--   return self:sub(-#suffix) == suffix
-- end
-- local function startswith(string, prefix)
--   return string:sub(1, #prefix) == prefix
-- end

local val = require("val")

---@type LazySpec
return {
  -- "jose-elias-alvarez/null-ls.nvim",
  [1] = "nvimtools/none-ls.nvim",
  lazy = true,
  enabled = true,
  event = { "VeryLazy" },
  cmd = { "NullLsInfo", "NullLsLog" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/CONFIG.md
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
  opts = function(_, opts)
    opts = vim.tbl_deep_extend("force", opts, {
      debug = false,
      fallback_severity = vim.diagnostic.severity.WARN,

      -- diagnostics_format = "#{m} (#{s})",
      diagnostics_format = "[#{c}] #{m} (#{s})",
      -- root_dir = require("null-ls.utils").root_pattern(unpack(val.root_patterns)),
      sources = {},
      on_attach = val.on_attach,

      should_attach = function(bufnr)
        if vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "" then
          return false
        end
        return true
      end,
    })

    return opts
  end,
  config = function(_, opts)
    local null_ls = require("null-ls")
    null_ls.setup(opts)
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      ---@param opts myLualineOpts
      opts = function(_, opts)
        local utils = require("utils")
        local hide_width = 40
        local truc_width = 100
        local num_source_semi_limit = 2

        -- TODO: null-ls 타입(diagnostics, formatter)에 따라 우선 순위로 정렬 <2024-01-10>
        local suppress_sources = {
          codespell = true,
        }
        local icon = utils.enable_icon and (require("val").icons.null .. " ")
          or ""

        local modules = require("lualine_require").lazy_require({
          sources = "null-ls.sources",
        })

        local component = {
          [1] = function()
            local lualine_width = require("val.plugins.lualine").options.globalstatus
                and vim.o.columns
              or vim.fn.winwidth(0)

            if lualine_width < hide_width then
              return ""
            end

            local clients =
              vim.lsp.get_active_clients({ bufnr = 0, name = "null-ls" })
            local is_null_ls = #clients ~= 0

            local names = {}
            if is_null_ls then
              for _, source in
                ipairs(modules.sources.get_available(vim.bo.filetype))
              do
                if
                  not names[source.name] and not suppress_sources[source.name]
                then
                  table.insert(names, source.name)
                  names[source.name] = true
                end
              end
            end

            if next(names) == nil then
              return ""

              -- if vim.bo.buftype ~= "" or vim.bo.filetype == "text" then
              --   return ""
              -- end
              --
              -- return (
              --   require("utils").enable_icon and (icon .. val.icons.empty_set)
              --   or "No soures attached"
              -- )
            end

            if lualine_width < truc_width then
              return (string.format("%s[%s]", icon, #names))
            end

            if
              #names > num_source_semi_limit
              and (#names - num_source_semi_limit) > 1
            then
              return string.format(
                "%s%s +[%s]",
                icon,
                table.concat({ unpack(names, 1, num_source_semi_limit) }, ", "),
                #names - num_source_semi_limit
              )
            end

            return string.format("%s%s", icon, table.concat(names, ", "))
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
            priority = 91,
          },
        })
      end,
    },
  },
}
