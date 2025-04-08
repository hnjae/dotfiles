-- WIP: 작동 안됨

-- LazyExtra's coding.nvim-cmp

---@type LazySpec
return {
  [1] = "hrsh7th/nvim-cmp",
  optional = true,
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    -- opts.mapping = opts.mapping or {}
    local cmp = require("cmp")

    opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.get_selected_entry() then
        cmp.confirm()
      elseif vim.snippet.active({ direction = 1 }) then
        -- luasnip.expand_or_jump()
        -- vim.snippet.expand()
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      else
        fallback()
      end
    end, { "i", "s" })

    -- FIX: not working
    opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = -1 }) then
        vim.schedule(function()
          vim.snippet.jump(-1)
        end)
      else
        fallback()
      end
    end, { "i", "s" })
  end,
  specs = {
    {
      [1] = "folke/lazydev.nvim",
      optional = true,
      opts = {
        library = {
          "nvim-cmp",
        },
      },
    },
  },
}
