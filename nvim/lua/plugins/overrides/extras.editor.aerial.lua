---@type LazySpec[]
return {
  {
    [1] = "aerial.nvim",
    optional = true,
    opts = {
      layout = {
        max_width = { 30, 0.2 }, -- default: 40, 0.2
        -- min_width = 10,

        attach_mode = "global",
        default_direction = "right", -- default: prefer_right
        placement = "edge", -- default: window
      },
      --   switch_buffer - close aerial when you change buffers in the source window
      -- close_automatic_events = { "switch_buffer" },
      --   unfocus       - close aerial when you leave the original source window
      -- close_automatic_events = { "unfocus" },
      open_automatic = function(bufnr)
        local aerial = require("aerial")

        return vim.api.nvim_buf_line_count(bufnr) > 80
          and aerial.num_symbols(bufnr) > 4
          and not aerial.was_closed()
          and (
            vim.fn.winwidth(0)
              - (vim.bo.textwidth ~= 0 and vim.bo.textwidth or 80) -- textwidth
              - 8 -- statuscolumn
              - 10 -- min aerial width
            -- - math.min(20, math.floor(vim.o.columns * 0.2))
            >= 0
          )
      end,
    },
    keys = {
      {
        "<leader>cs",
        function()
          require("aerial").toggle({ focus = false })
        end,
        desc = "Aerial (Symbols)",
      },
    },
  },
  {
    [1] = "aerial.nvim",
    optional = true,
    opts = function()
      vim.api.nvim_create_autocmd("WinClosed", {
        callback = function(ev)
          -- NOTE:
          -- ev.buf: 닫힌 윈도우의 버퍼

          if vim.api.nvim_get_option_value("buftype", { buf = ev.buf }) == "nofile" then
            return
          end

          -- HACK: 커서가 다른 윈도우에 포커스 되었다고 가정하기 위해 대기 <2025-04-22>
          vim.defer_fn(function()
            local buf = vim.api.nvim_get_current_buf()
            if vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "aerial" then
              return
            end

            vim.cmd(":q")

            -- 아래 두개로 제거하면 안됨
            -- require("snacks").bufdelete(buf)
            -- require("aerial").close()
          end, 1)

          -- vim.notify("hi")

          -- local tabid = vim.api.nvim_win_get_tabpage(tonumber(ev.match))
          -- -- local tabid = vim.api.nvim_get_current_tabpage()
          -- local winids = vim.api.nvim_tabpage_list_wins(tabid)
          --
          -- local is_aerial = false
          -- for _, winid in ipairs(winids) do
          --   local buf = vim.api.nvim_win_get_buf(winid)
          --
          --   if vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "nofile" then
          --     vim.notify(vim.inspect(vim.fn.getbufinfo(buf)))
          --     return
          --   end
          --
          --   if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "aerial" then
          --     is_aerial = true
          --   end
          -- end
          --
          -- if is_aerial then
          --   vim.notify("hello!")
          --   -- require("aerial").close()
          -- end
        end,
      })
    end,
  },
}
