---@type LazySpec
return {
  [1] = "williamboman/mason-lspconfig.nvim",
  lazy = true,
  event = { "VeryLazy" },
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
}
