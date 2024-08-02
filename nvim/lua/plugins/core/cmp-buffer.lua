---@type LazySpec
return {
  [1] = "hrsh7th/cmp-buffer",
  optional = true,
  specs = {
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = { "hrsh7th/cmp-buffer" },
      ---@param opts myCmpConfig
      opts = function(_, opts)
        local cmp = require("cmp")
        opts.sources = vim.list_extend(
          opts.sources or {},
          cmp.config.sources({
            {
              name = "buffer",
              priority = 0,
              max_item_count = 8,
              option = {
                get_bufnrs = function()
                  -- use all buffers
                  -- return vim.api.nvim_list_bufs()

                  -- use all buffers in current tab
                  vim.api.nvim_tabpage_list_wins(0)
                  local bufs = {}
                  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                    table.insert(bufs, vim.api.nvim_win_get_buf(win))
                  end
                  return bufs
                end,
              },
            },
          })
        )

        opts.cmdline_search_sources = vim.list_extend(
          opts.cmdline_search_sources or {},
          require("cmp").config.sources({
            { name = "buffer" },
          })
        )
      end,
    },
  },
}
