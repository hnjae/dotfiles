---@type LazySpec
return {
  [1] = "stevearc/conform.nvim",
  lazy = true,
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = function(_, opts)
    local ret = {
      lsp_fallback = true,
      -- Define your formatters
      formatters_by_ft = {},
      -- format_on_save = { timeout_ms = 1000 },
      format_after_save = { lsp_fallback = true },
    }
    return vim.tbl_deep_extend("keep", ret, opts)
  end,
  keys = {
    {
      [1] = "==",
      [2] = function()
        require("conform").format({
          async = false,
          timeout_ms = 4000,
          quiet = false,
        }, function()
          local msg = "Format Done"
          vim.notify(msg, nil, {
            title = "Conform",
            timeout = 300,
            hide_from_history = true,
            animate = false,
          })
        end)
      end,
      desc = "Format",
      mode = "n",
    },
    -- {
    --   [1] = "==",
    --   [2] = function()
    --     require("conform").format({
    --       async = false,
    --       timeout_ms = 4000,
    --       quiet = false,
    --     }, function()
    --       local msg = "Format Done"
    --       vim.notify(msg, nil, {
    --         title = "Conform",
    --         timeout = 300,
    --         hide_from_history = true,
    --         animate = false,
    --       })
    --     end)
    --   end,
    --   desc = "Range-Format",
    --   mode = "v",
    -- },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    -- If you want the formatexpr, here is the place to set it
    -- 이게 == 대체할 것 (아마도)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
