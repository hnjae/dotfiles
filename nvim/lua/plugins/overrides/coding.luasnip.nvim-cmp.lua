-- LazyExtra's coding.luasnip and coding.nvim-cmp

---@type LazyPluginSpec
local spec = {
  [1] = "nvim-cmp",
  optional = true,
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif cmp.get_active_entry() then
        cmp.confirm()
      else
        fallback()
      end
    end, { "i", "s" })
    opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" })

    -- make this source first
    opts.sources = vim.list_extend(
      { { name = "luasnip" } },
      vim.tbl_filter(function(source)
        return source.name ~= "luasnip"
      end, opts.sources or {})
    )

    return opts
  end,
  specs = {},
}

---@type LazySpec
return {
  [1] = "LuaSnip",
  optional = true,
  specs = { spec },
}
