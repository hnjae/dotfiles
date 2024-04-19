local val = require("val")

---@type LazySpec
return {
  [1] = "famiu/bufdelete.nvim",
  lazy = true,
  cmd = {
    "Bdelete",
    "Bwipeout",
    "BdeleteHidden",
  },
  keys = {
    -- {
    --   [1] = val.prefix.close .. "b",
    --   [2] = "<cmd>Bdelete<CR>",
    --   desc = "Bdelete",

    -- },
    {
      [1] = val.prefix.close .. "b",
      [2] = "<cmd>BdeleteHidden<CR>",
      desc = "bdelete-hidden-s",
    },
  },
  config = function()
    vim.api.nvim_create_user_command("BdeleteHidden", function()
      local no_win_bufs = {}

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if
          vim.fn.bufloaded(bufnr) == 1
          and vim.fn.buflisted(bufnr) == 1
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

      -- if true then
      --   local msg = {}
      --   for _, bufnr in ipairs(no_win_bufs) do
      --     msg[bufnr] = {}
      --
      --     for _, option in ipairs({ "buftype", "filetype" }) do
      --       msg[bufnr][option] = vim.api.nvim_buf_get_option(bufnr, option)
      --     end
      --
      --     for _, x in ipairs({
      --       "bufname",
      --       "buflisted",
      --       "bufwinid",
      --       "bufwinnr",
      --       "bufloaded",
      --       "getbufinfo",
      --     }) do
      --       msg[bufnr][x] = vim.fn[x](bufnr)
      --     end
      --   end
      --
      --   require("messages.api").capture_thing(msg)
      -- end

      require("bufdelete").bufdelete(no_win_bufs)
      vim.notify(tostring(#no_win_bufs) .. " buffers deleted")
    end, {
      desc = "bdelete-hidden-s",
    })
  end,
}
