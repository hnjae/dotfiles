local val = require("val")

---@type LazySpec
return {
  [1] = "famiu/bufdelete.nvim",
  lazy = true,
  cmd = {
    "Bdelete",
    "Bwipeout",
  },
  keys = {
    -- {
    --   [1] = val.prefix.close .. "b",
    --   [2] = "<cmd>Bdelete<CR>",
    --   desc = "Bdelete",

    -- },
    {
      [1] = val.prefix.close .. "b",
      [2] = function()
        local no_win_bufs = {}

        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if
            vim.fn.bufloaded(bufnr) == 1
            and vim.fn.bufwinid(bufnr) == -1
            and vim.fn.getbufinfo(bufnr)[1].changed == 0
          then
            table.insert(no_win_bufs, bufnr)
          end
        end

        if next(no_win_bufs) == nil then
          vim.notify("No buffers to delete")
          return
        end

        require("bufdelete").bufdelete(no_win_bufs)
      end,

      desc = "bdelete-hidden-buffers",
    },
  },
}
