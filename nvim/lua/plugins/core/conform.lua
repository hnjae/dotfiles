-- Formatter

---@type LazySpec
return {
  [1] = "stevearc/conform.nvim",
  lazy = true,
  enabled = true,
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = function(_, opts)
    local default = {
      default_format_opts = {
        lsp_format = "never",
        -- stop_after_first = false,
      },
      notify_no_formatters = false,
      -- Define your formatters
      formatters_by_ft = {},
      -- format_on_save = { timeout_ms = 1000 },
      format_after_save = { lsp_fallback = true },
    }

    return vim.tbl_deep_extend("keep", default, opts)
  end,
  keys = {
    {
      [1] = "==",
      [2] = function()
        require("conform").format({
          async = false,
          timeout_ms = 4000,
          quiet = false,
        }, function()
          local msg = "Format Done"
          vim.notify(msg, nil, {
            title = "Conform",
            timeout = 350,
            hide_from_history = true,
            animate = false,
          })
        end)
      end,
      desc = "Format",
      mode = "n",
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    local filetypes = {}
    for ft, _ in pairs(opts.formatters_by_ft) do
      table.insert(filetypes, ft)
    end

    -- 이게 == (아마), `gq` 대체할 것
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = filetypes,
      callback = function()
        vim.opt_local.formatexpr = "v:lua.require'conform'.formatexpr()"
      end,
    })
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

        local icon = utils.use_icons and (require("globals").icons.sort .. " ")
          or ""

        local modules = require("lualine_require").lazy_require({
          conform = "conform",
        })

        local component = {
          [1] = function()
            local lualine_width = require("val.plugins.lualine").options.globalstatus
                and vim.o.columns
              or vim.fn.winwidth(0)

            if lualine_width < hide_width then
              return ""
            end

            local formatters, will_fallback_lsp =
              modules.conform.list_formatters_to_run(0)

            local names = {}
            for _, formatter in ipairs(formatters) do
              table.insert(names, formatter.name)
            end

            if #names == 0 and will_fallback_lsp then
              table.insert(names, "LSP")
            end

            if #names == 0 then
              return ""
              -- if vim.bo.buftype ~= "" or vim.bo.filetype == "text" then
              -- end
              --
              -- return (
              --   require("utils").use_icons and (icon .. val.icons.empty_set)
              --   or "No formatter available"
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

        opts.sections = opts.sections or {}
        opts.sections.lualine_x = opts.sections.lualine_x or {}

        table.insert(opts.sections.lualine_x, {
          component = component,
          priority = 92,
        })
      end,
    },
  },
}
