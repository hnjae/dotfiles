local function is_devenv_nix(bufnr)
  return vim.api.nvim_buf_get_name(bufnr):find("devenv", 1, true) ~= nil
end

local function nix_root_dir(bufnr, on_dir)
  if is_devenv_nix(bufnr) and vim.fn.executable("devenv") == 1 then
    return
  end

  on_dir(vim.fs.root(bufnr, { "flake.nix", ".git" }))
end

--[[
  NOTE:
    Overrides `lang.nix` from LazyExtra
--]]

---@type LazySpec[]
return {
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.nil_ls = nil

      if vim.fn.executable("devenv") == 1 then
        opts.servers.devenv = {
          cmd = { "devenv", "lsp" },
          filetypes = { "nix" },
          mason = false,
          root_dir = function(bufnr, on_dir)
            if is_devenv_nix(bufnr) then
              on_dir(vim.fs.root(bufnr, { "devenv.nix", "devenv.yaml", "devenv.lock", ".git" }))
            end
          end,
        }
      end

      if vim.fn.executable("nixd") == 1 then
        opts.servers.nixd = {
          root_dir = nix_root_dir,
        }
        opts.servers.nil_ls = nil
      elseif vim.fn.executable("nil") ~= 1 then
        opts.servers.nil_ls = {
          root_dir = nix_root_dir,
        }
      end
    end,
  },
  {
    [1] = "nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.nix = opts.linters_by_ft.nix or {}

      local linters = {
        "statix",
        "deadnix",
      }

      for _, linter in ipairs(linters) do
        if vim.fn.executable(linter) == 1 then
          table.insert(opts.linters_by_ft.nix, linter)
        end
      end

      return opts
    end,
    specs = {
      -- NOTE: 제공 안함 <2025-04-09>
      --[[ {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = {} },
    }, ]]
    },
  },
  {
    -- :h conform-formatters
    -- https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      require("conform").formatters.nixfmt = {
        prepend_args = function()
          if vim.bo.textwidth ~= 0 then
            return { "-w", tostring(vim.bo.textwidth) }
          end

          return {}
        end,
      }

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.nix = { "nixfmt" }
    end,
  },
}
