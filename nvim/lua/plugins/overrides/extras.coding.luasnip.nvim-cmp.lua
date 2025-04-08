-- LazyExtra's coding.luasnip and coding.cmp

---@type LazyPluginSpec
local spec = {
  [1] = "nvim-cmp",
  optional = true,
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.get_active_entry() then
        cmp.confirm()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
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
    local new_source = { { name = "luasnip" } }
    for _, source in ipairs(opts.sources) do
      if source.name ~= "luasnip" then
        table.insert(new_source, source)
      end
    end
    opts.sources = new_source
  end,
  specs = {},
}

---@type LazySpec
return {
  [1] = "LuaSnip",
  optional = true,
  specs = { spec },
}
