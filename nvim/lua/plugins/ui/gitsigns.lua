local prefix = require("globals").prefix
local map_keyword = require("globals").map_keyword

---@type LazySpec
return {
  [1] = "lewis6991/gitsigns.nvim",
  enabled = true,
  lazy = true,
  event = "VeryLazy",
  opts = {},
  ---@type fun(self:LazyPlugin, keys:LazyKeysSpec[])
  keys = function(_, keys)
    local bp = "<LocalLeader>" .. map_keyword.git -- buffer perifx

    -- local bky = prefix.buffer[#prefix.buffer] -- buffer keyword

    local gitsigns = require("gitsigns")

    local buffer_mapping = {
      -- stylua: ignore start
      { desc = "preview-hunk",    [1] = bp .. "p", [2] = "<cmd>Gitsigns preview_hunk<CR>" },
      { desc = "stage-hunk",      [1] = bp .. "h", [2] = "<cmd>Gitsigns stage_hunk<CR>",  mode = {"n"} },
      { desc = "stage-hunk",      [1] = bp .. "h", [2] = ":'<,'>Gitsigns stage_hunk<CR>", mode = {"v"} },
      { desc = "undo-stage-hunk", [1] = bp .. "u", [2] = "<cmd>Gitsigns undo_stage_hunk<CR>", mode = {"n"} },
      { desc = "undo-stage-hunk", [1] = bp .. "u", [2] = ":'<,'>Gitsigns undo_stage_hunk<CR>", mode = {"v"} },
      { desc = "stage-buffer",    [1] = bp .. "H", [2] = function () gitsigns.stage_buffer({async=true}) end  },
      { desc = "blame",    [1] = bp .. "b", [2] = "<cmd>Gitsigns blame_line<CR>" },
      { desc = "blame",    [1] = bp .. "B", [2] = "<cmd>Gitsigns blame<CR>" },
      -- stylua: ignore end
    }
    vim.list_extend(keys, buffer_mapping)

    local move_mapping = {
      -- stylua: ignore start
      { [1] = "]h", [2] = "<cmd>Gitsigns next_hunk<CR>", desc = "next-git-hunk" },
      { [1] = "[h", [2] = "<cmd>Gitsigns prev_hunk<CR>", desc = "prev-git-hunk" },
      -- stylua: ignore end
    }
    vim.list_extend(keys, move_mapping)
  end,
  specs = {
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      ---@class wk.Opts
      opts = function(_, opts)
        opts.spec = opts.spec or {}
        opts.icons = opts.icons or {}
        opts.icons.rules = opts.icons.rules or {}

        vim.list_extend(opts.icons.rules, {
          {
            plugin = "gitsigns.nvim",
            icon = require("globals").icons.git,
            color = "orange",
          },
        })

        table.insert(opts.spec, {
          [1] = prefix.buffer .. map_keyword.git,
          group = "gitsigns",
        })
      end,
    },
  },
}
