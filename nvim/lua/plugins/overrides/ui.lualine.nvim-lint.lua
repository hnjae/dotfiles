---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local lint = require("lint")
    local num_source_light_imit = 2
    local truc_width = 100

    local fmt = function(icon, linters)
      local lualine_width = vim.o.columns -- or vim.fn.winwidth(0) if not using globalstatus

      if lualine_width < truc_width then
        return (string.format("%s[%s]", icon, #linters))
      end

      if #linters > num_source_light_imit and (#linters - num_source_light_imit) > 1 then
        return string.format(
          "%s%s +[%s]",
          icon,
          table.concat({ unpack(linters, 1, num_source_light_imit) }, ", "),
          #linters - num_source_light_imit
        )
      end

      return string.format("%s%s", icon, table.concat(linters, ", "))
    end

    local component = {
      [1] = function()
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if #linters == 0 then
          return ""
        end

        local is_running = #(require("lint").get_running()) > 0
        if is_running then
          return fmt(" ", linters)
          -- return " " .. table.concat(linters, ", ") -- nf-oct-codescan
          -- return " " .. table.concat(linters, ", ") -- nf-cod-sync
        end

        -- return " " .. table.concat(linters, ", ") -- nf-oct-check_circle
        -- return " " .. table.concat(linters, ", ") -- nf-cod-issues
        return fmt(" ", linters)
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
