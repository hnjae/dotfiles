local M = {}

M.setup = function()
  vim.api.nvim_create_user_command("BdeleteHidden", function()
    local hidden_buffers = vim.tbl_filter(function(bufnr)
      local bufinfo = vim.fn.getbufinfo(bufnr)[1]
      if
        bufinfo.hidden == 1 -- buffer is no longer displayed in a window
        and bufinfo.loaded == 1 -- shown in a window or hidden
        and bufinfo.listed == 1 -- buffer shows up in the buffer list
        and bufinfo.changed == 0 -- 변경 사항이 있는 버퍼 제외
        and bufinfo.name ~= "" -- no name (empty) buffer 제외
        and vim.bo[bufnr].buftype == "" -- nofile 등 특수 버퍼 제외
      then
        return true
      end

      return false
    end, vim.api.nvim_list_bufs())

    if #hidden_buffers == 0 then
      vim.notify("No buffers to delete")
      return
    end

    for _, bufnr in ipairs(hidden_buffers) do
      vim.api.nvim_buf_delete(bufnr, {})
    end

    vim.notify(tostring(#hidden_buffers) .. " buffer(s) deleted")
  end, {})

  vim.keymap.set({ "n" }, "<Leader>bh", "<cmd>BdeleteHidden<CR>", {
    desc = "Delete all hidden buffers",
  })
end

return M
