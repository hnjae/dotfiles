local prefix = require("val.prefix")
local map_keyword = require("val.map-keyword")

---@type LazySpec
return {
  [1] = "lewis6991/gitsigns.nvim",
  enabled = true,
  lazy = true,
  event = "VeryLazy",
  opts = {},
  ---@type LazyKeysSpec[]
  keys = {
    -- stylua: ignore start
    { [1] = prefix.buffer .. map_keyword.git,        [2] = nil,                                 desc = "+git"            },
    { [1] = prefix.buffer .. map_keyword.git .. "p", [2] = "<cmd>Gitsigns preview_hunk<CR>",    desc = "preview-hunk"    },
    { [1] = prefix.buffer .. map_keyword.git .. "s", [2] = "<cmd>Gitsigns stage_hunk<CR>",      desc = "stage-hunk"      },
    { [1] = prefix.buffer .. map_keyword.git .. "u", [2] = "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "undo-stage-hunk" },
    -- stylua: ignore end

    -- stylua: ignore start
    { [1] = "]" .. map_keyword.git, [2] = "<cmd>Gitsigns next_hunk<CR>", desc = "next-hunk" },
    { [1] = "[" .. map_keyword.git, [2] = "<cmd>Gitsigns prev_hunk<CR>", desc = "prev-hunk" },
    -- stylua: ignore end
  },
}
