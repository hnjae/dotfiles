---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local lint = require("lint")

    -- Memoization cache (buffer number -> linters list)
    local linters_cache = {}

    -- Clear cache on buffer delete to free memory
    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function(ev)
        linters_cache[ev.buf] = nil
      end,
    })

    -- Clear cache on filetype change as linters may differ
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        linters_cache[ev.buf] = nil
      end,
    })

    -- Clear all cache on lazy.nvim reload as config may have changed
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyReload",
      callback = function()
        linters_cache = {}
      end,
    })

    local get_linters = function(bufnr)
      -- Only process normal buffers (ignore special buffers like help, terminal, nofile, etc.)
      if vim.bo[bufnr].buftype ~= "" then
        return {}
      end

      -- Convert 0 to actual current buffer number for caching
      if bufnr == 0 then
        bufnr = vim.api.nvim_get_current_buf()
      end

      -- Check cache
      if linters_cache[bufnr] then
        return linters_cache[bufnr]
      end

      ----------------------------
      -- Based on code from LazyVim (2026-01-13)
      -- Copyright (c) 2024 LazyVim
      -- Licensed under the Apache License 2.0
      -- Source: https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/plugins/linting.lua
      local names = lint._resolve_linter_by_ft(vim.bo[bufnr].filetype)

      -- Create a copy of the names table to avoid modifying the original.
      names = vim.list_extend({}, names)

      -- Add fallback linters.
      if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
      end

      -- Add global linters.
      vim.list_extend(names, lint.linters_by_ft["*"] or {})

      -- Filter out linters that don't exist or don't match the condition.
      local ctx = { filename = vim.api.nvim_buf_get_name(bufnr) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        ---@diagnostic disable-next-line: undefined-field
        return linter
          and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
      end, names)

      -- Store in cache
      linters_cache[bufnr] = names

      return names
    end

    local hide_width = 65
    local truc_width = 110
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

    local component = function()
      if vim.o.columns <= hide_width then
        return ""
      end

      local linters = get_linters(0)
      if #linters == 0 then
        return ""
      end

      local is_running = #(lint.get_running()) > 0

      -- 󰓦  nf-md-sync
      -- 󰗡  nf-md-check_circle_outline
      local icon = is_running and "󰓦 " or "󰗡 "
      return fmt(icon, linters)
    end

    table.insert(opts.sections.lualine_x, component)
  end,
}

---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  specs = { spec },
}
