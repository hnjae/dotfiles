---@type LazySpec[]
return {
  {
    [1] = "snacks.nvim",
    optional = true,
    keys = {
      -- LazyVim 14.14.0
      -- map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
      -- { [1] = "<leader>bo", [2] = false }, -- in keymaps/init.lua
      {
        [1] = "<leader>bh",
        [2] = function()
          local snacks = require("snacks")

          local hidden_buffers = vim.tbl_filter(function(bufnr)
            local bufinfo = vim.fn.getbufinfo(bufnr)[1]
            if
              bufinfo.hidden == 1 -- buffer is no longer displayed in a window
              and bufinfo.loaded == 1 -- shown in a window or hidden
              and bufinfo.listed == 1 -- buffer shows up in the buffer list
              -- and bufinfo.changed == 0 -- 변경 사항이 있는 버퍼 제외 (snacks 가 저장할지 물어봄)
              -- and bufinfo.name ~= "" -- no name (empty) buffer 제외
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
            -- vim.api.nvim_buf_delete(bufnr, {})
            snacks.bufdelete(bufnr)
          end

          vim.notify(tostring(#hidden_buffers) .. " buffer(s) deleted")
        end,
        desc = "delete-hidden-buffers",
      },
    },
    specs = {
      {
        [1] = "which-key.nvim",
        optional = true,
        -- ---@type wk.Opts
        opts = {
          ---@type wk.Spec
          spec = {
            { [1] = "<leader>bh", mode = { "n" }, icon = { icon = "󰘓 " } },
          },
        },
      },
    },
  },
  {
    [1] = "bufferline.nvim",
    optional = true,
    keys = {
      -- LazyVim 14.14.0
      -- { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      -- { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { [1] = "<leader>br", [2] = false },
      { [1] = "<leader>bl", [2] = false },

      -- neovim 0.11.0 maps `[b`, `]b` by default
      -- { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      -- { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", false },
      { "]b", false },
    },
  },
}
