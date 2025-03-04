local val = require("val")
local icons = val.icons
local utils = require("utils")

return {
  [1] = "TimUntersberger/neogit",
  enabled = true,
  lazy = true,
  cmd = {
    "Neogit",
    "NeogitResetState",
    "NeogitCommit",
    "NeogitLog",
  },
  opts = {
    notification_icon = utils.enable_icon and icons.git or "G",
    graph_style = utils.enable_icon and "unicode" or "ascii",
    disable_line_numbers = false,
    disable_relative_line_numbers = false,

    mappings = {
      -- popup = {
      --   ["Z"] = nil,
      --   ["z"] = "StashPopup",
      -- },
    },
  },
  keys = {
    {
      [1] = val.prefix.git .. val.map_keyword.git,
      [2] = "<cmd>Neogit<CR>",
      desc = "open-neogit",
    },
    -- not working
    -- {
    --   [1] = val.prefix.git .. "c",
    --   [2] = function()
    --     require("neogit").action("commit", "commit", {})
    --   end,
    --   desc = "commit",
    -- },
    {
      [1] = val.prefix.git .. "C",
      [2] = "<cmd>Neogit commit<CR>",
      desc = "commit-popup",
    },
    {
      [1] = "<LocalLeader>" .. val.map_keyword.git .. "l",
      [2] = "<cmd>NeogitLog<CR>",
      [3] = "neogit-log",
    },
  },
  config = function(_, opts)
    local MAX_COLORCOLUMN = 200

    -- neogit 에서는 bufnolisted 로 gitcommit 이 열려, 별도로 설정하는 로직 추가 <2025-03-02>
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = { "gitcommit" },
      callback = function()
        local textwidth = vim.opt_local.textwidth:get()
        if
          not textwidth
          or textwidth < 1
          or (textwidth + 1) > MAX_COLORCOLUMN
        then
          if vim.opt_local.colorcolumn ~= "" then
            vim.opt_local.colorcolumn = ""
          end

          return
        end

        -- NOTE: range에는 starts, end 전부 포함됨 <2023-12-11>
        vim.opt_local.colorcolumn =
          vim.fn.join(vim.fn.range(textwidth + 1, MAX_COLORCOLUMN), ",")
      end,
    })

    require("neogit").setup(opts)
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        require("state.lualine-ft-data"):add({
          NeogitStatus = { display_name = "NeogitStatus", icon = icons.git },
          -- NeogitWorkTreePopup
          -- NeogitCommitMessage
          -- NeogitPopUp
        })
      end,
    },
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      ---@class wk.Opts
      opts = function(_, opts)
        opts.spec = opts.spec or {}
        opts.icons = opts.icons or {}
        opts.icons.rules = opts.icons.rules or {}
        local icon = require("val.icons").git

        vim.list_extend(opts.icons.rules, {
          {
            plugin = "neogit",
            icon = icon,
            color = "orange",
          },
        })
      end,
    },
  },
}
