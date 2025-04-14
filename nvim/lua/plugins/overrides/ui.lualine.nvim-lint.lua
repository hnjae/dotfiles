---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local lint = require("lint")

    local hide_width = 65
    local truc_width = 110
    -- local lualine_width = vim.o.columns -- or vim.fn.winwidth(0) if not using globalstatus
    local num_source_light_limit = 1

    local fmt = function(icon, linters)
      if vim.o.columns < truc_width then
        return (string.format("%s[%s]", icon, #linters))
      end

      if #linters > num_source_light_limit and (#linters - num_source_light_limit) > 1 then
        return string.format(
          "%s%s +[%s]",
          icon,
          table.concat({ unpack(linters, 1, num_source_light_limit) }, ", "),
          #linters - num_source_light_limit
        )
      end

      return string.format("%s%s", icon, table.concat(linters, ", "))
    end

    local component = {
      [1] = function()
        local linters = lint.linters_by_ft[vim.bo.filetype]

        -- if linters == nil or #linters == 0 then
        --   return ""
        -- end

        local is_running = #(require("lint").get_running()) > 0
        if is_running then
          -- " " -- nf-oct-codescan
          -- " " -- nf-cod-sync
          return fmt(" ", linters)
        end

        -- " " -- nf-oct-check_circle
        -- " " -- nf-cod-issues
        return fmt(" ", linters)
      end,
      cond = function()
        local linters = lint.linters_by_ft[vim.bo.filetype]

        return (vim.o.columns > hide_width) and (linters ~= nil and #linters > 0)
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
