-- https://github.com/wfxr/minimap.vim
-- https://github.com/lewis6991/satellite.nvim?tab=readme-ov-file

---@type LazySpec
return {
  [1] = "wfxr/minimap.vim",
  lazy = true,
  event = "VeryLazy",
  cond = vim.fn.executable("code-minimap") == 1,
  -- cond = not require("utils").is_console,
  -- build = "cargo install --locked code-minimap",
  cmd = {
    "Minimap",
    "MinimapClose",
    "MinimapToggle",
    "MinimapRefresh",
    "MinimapUpdateHighlight",
    "MinimapRescan",
  },
  init = function()
    vim.g.minimap_width = 4 -- default 10
    vim.g.minimap_left = 1
    vim.g.minimap_block_filetypes = {
      "fugitive",
      "nerdtree",
      "tagbar",
      "fzf",
      "TelescopePrompt",
      "OverseerList",
      "Outline",
      "toggleterm",
      "noice",
      "notify",
      "NvimTree",
      "alpha",
      "lazy",
      "help",
      "oil",
    }
    vim.g.minimap_close_filetypes = {
      "startify",
      "netrw",
      "vim-plug",
    }
    vim.g.minimap_block_buftypes = {
      "nofile",
      "nowrite",
      "quickfix",
      "terminal",
      "prompt",
      "picker",
      "acwrite",
    }
    vim.g.minimap_git_colors = 1

    -- TODO: auto open minimap if columns are enough to open
    -- if vim.o.columns > 80 then
    --   print("1")
    --   vim.w.minimap_auto_start = 1
    -- end

    -- autocmd FileType help setlocal minimap_auto_start=0

    -- vim.g.minimap_auto_start = 1
    -- vim.g.minimap_auto_start_win_enter = 1

    -- vim.api.nvim_create_autocmd("WinClosed", {
    --   callback = function(ev)
    --     -- NOTE:
    --     -- ev.buf: 닫힌 윈도우의 버퍼
    --
    --     if vim.api.nvim_get_option_value("buftype", { buf = ev.buf }) ~= "" then
    --       return
    --     end
    --
    --     -- HACK: 커서가 다른 윈도우에 포커스 되었다고 가정하기 위해 대기 <2025-04-22>
    --     vim.defer_fn(function()
    --       local buf = vim.api.nvim_get_current_buf()
    --       if vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "minimap" then
    --         return
    --       end
    --
    --       vim.cmd("quit")
    --     end, 1)
    --   end,
    -- })

    vim.api.nvim_create_autocmd({ "VimEnter", "TabEnter" }, {
      callback = function(ev)
        if vim.api.nvim_get_option_value("buftype", { buf = ev.buf }) ~= "" then
          return
        end

        local textwidth = vim.api.nvim_get_option_value("textwidth", { buf = ev.buf })
        textwidth = textwidth > 0 and textwidth or 80

        local STATUSCOLUMNWIDTH = 8
        local aerial_min_width = 10

        local winid = vim.fn.bufwinid(ev.buf)
        local winwidth = vim.fn.winwidth(winid)
        local visualwidth = winwidth
          - STATUSCOLUMNWIDTH
          - (vim.g.minimap_width + 2)
          - aerial_min_width

        if visualwidth > textwidth then
          vim.cmd("Minimap")
        end
      end,
    })
  end,
  specs = {
    {
      [1] = "snacks.nvim",
      optional = true,
      ---@type snacks.Config
      opts = {
        notifier = {
          filter = function(foo)
            vim.notify(vim.inspect(foo))
          end,
        },
      },
    },
  },
}
