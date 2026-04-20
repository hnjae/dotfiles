local mason_utils = require("utils.mason")

---@type LazySpec[]
return {
  {
    [1] = "mason.nvim",
    optional = true,
    ---@type MasonSettings
    opts = {
      PATH = "append", -- Mason's bin location is put at the end of PATH
      max_concurrent_installers = 3, -- default: 4
      log_level = vim.log.levels.WARN,
    },
    ---@param opts MasonSettings | { ensure_installed?: string[] }
    config = function(_, opts)
      local skipped = mason_utils.filter_ensure_installed(opts)

      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed or {}) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)

      mason_utils.notify_skipped(
        "mason.nvim",
        "Skipping Mason packages with missing prerequisites: ",
        skipped
      )
    end,
    specs = {},
  },
  {
    [1] = "mason-lspconfig.nvim",
    optional = true,
    opts = {
      automatic_enable = {
        exclude = {
          "nil_ls", -- requires nix
        },
      },
    },
  },
  {
    [1] = "nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      local mappings = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
      local skipped = {}

      for server, sopts in pairs(opts.servers or {}) do
        if server ~= "*" and mappings[server] then
          local server_opts = sopts == true and {} or sopts
          if
            type(server_opts) == "table"
            and server_opts.enabled ~= false
            and server_opts.mason ~= false
          then
            local pkg_name = mappings[server]
            local missing = mason_utils.missing_prerequisites(pkg_name)
            if #missing > 0 then
              server_opts.mason = false
              skipped[#skipped + 1] = ("%s -> %s (%s)"):format(
                server,
                pkg_name,
                table.concat(missing, ", ")
              )
              opts.servers[server] = server_opts
            end
          end
        end
      end

      mason_utils.notify_skipped(
        "mason-lspconfig.nvim",
        "Skipping Mason-managed LSP installs with missing prerequisites: ",
        skipped
      )
    end,
  },
}
