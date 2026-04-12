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

      if vim.fn.executable("nixd") == 1 then
        opts.servers.nixd = {}
        opts.servers.nil_ls = nil
      elseif vim.fn.executable("nix") ~= 1 then
        opts.servers.nil_ls = nil
      end
    end,
  },
}
