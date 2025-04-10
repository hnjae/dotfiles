--[[
  NOTE:
    override `lang.nix` from LazyVim
--]]
---@type LazySpec
return {
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
}
