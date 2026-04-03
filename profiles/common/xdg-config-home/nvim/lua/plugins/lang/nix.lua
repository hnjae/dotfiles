--[[
  NOTE:
    Overrides `lang.nix` from LazyExtra
--]]
---@type LazySpec[]
return {
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("nix") ~= 1 then
        opts.servers.nil_ls = nil
      end
    end,
  },
}
