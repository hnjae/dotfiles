---@type LazySpec
return {
  [1] = "delphinus/cmp-ctags",
  enabled = false and vim.fn.executable("ctags") == 1,
  specs = {
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = {
        "delphinus/cmp-ctags",
      },
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        local cmp = require("cmp")
        if not opts.sources then
          opts.sources = {}
        end
        vim.list_extend(
          opts.sources,
          cmp.config.sources({
            { name = "ctags" },
          })
        )
      end,
    },
  },
}
