-- TODO: change BdeleteHidden name <2024-11-08>
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
      desc = "bdelete-hidden",
    },
  },
  config = function()
    vim.api.nvim_create_user_command("BdeleteHidden", function()
      local no_win_bufs = {}

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local bufinfo = vim.fn.getbufinfo(bufnr)[1]
        if
          -- vim.fn.bufloaded(bufnr) == 1
          -- and vim.fn.buflisted(bufnr) == 1
          -- and vim.fn.bufwinid(bufnr) == -1
          -- and vim.fn.bufwinnr(bufnr) == -1 -- do I need this?
          bufinfo.hidden == 1 -- buffer is no longer displayed in a window
          and bufinfo.loaded == 1 -- shown in a window or hidden
          and bufinfo.listed == 1 -- buffer shows up in the buffer list
          and bufinfo.changed == 0
          and bufinfo.name ~= ""
          and vim.bo[bufnr].buftype == ""
          -- and #bufinfo.windows == 0
          -- and not vim.api.nvim_buf_is_valid(bufnr) -- do I need this?
        then
          -- vim.notify(vim.inspect(bufinfo))
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
      vim.notify(tostring(#no_win_bufs) .. " buffer(s) deleted")
    end, {
      desc = "bdelete-hidden",
    })
  end,
}
