---@type LazySpec
return {
  [1] = "hrsh7th/cmp-emoji",
  optional = true,
  specs = {
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = { "hrsh7th/cmp-emoji" },
      ---@param opts myCmpOpts
      opts = function(_, opts)
        if not opts.sources then
          opts.sources = {}
        end
        table.insert(opts.sources, { name = "emoji" })
        -- opts.sources = vim.list_extend(
        --   opts.sources or {},
        --   cmp.config.sources({ { name = "emoji" } })
        -- )
      end,
    },
  },
}
