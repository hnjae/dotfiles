---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local lint = require("lint")

    local component = {
      [1] = function()
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if #linters == 0 then
          return ""
        end

        local is_running = #(require("lint").get_running()) > 0
        if is_running then
          -- return " " .. table.concat(linters, ", ") -- nf-oct-codescan
          return " " .. table.concat(linters, ", ") -- nf-cod-sync
        end

        -- return " " .. table.concat(linters, ", ") -- nf-oct-check_circle
        return " " .. table.concat(linters, ", ") -- nf-cod-issues
      end,
    }

    table.insert(opts.sections.lualine_x, component)
  end,
}

---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  specs = { spec },
}
