-- TODO: hop.nvim is now deprecated <2023-12-27>
-- Check following plugins:
-- https://github.com/ggandor/leap.nvim
-- https://github.com/rlane/pounce.nvim

---@type LazySpec
return {
  [1] = "phaazon/hop.nvim",
  branch = "v2",
  -- NOTE: macro에 간섭하는데 어떻게 끌수 있는지 모르겠다. <2023-06-09>
  enabled = true,
  lazy = true,
  opts = {
    {
      keys = "etovxqpdygfblzhckisuran",
    },
  },
  ---@type LazyKeysSpec[]
  keys = {
    { [1] = "f", [2] = nil, remap = true, desc = "hop-f" },
    { [1] = "F", [2] = nil, remap = true, desc = "hop-F" },
    { [1] = "t", [2] = nil, remap = true, desc = "hop-t" },
    { [1] = "T", [2] = nil, remap = true, desc = "hop-T" },
  },
  config = function(plugin, opts)
    local hop = require("hop")
    hop.setup(opts)

    local directions = require("hop.hint").HintDirection
    local mapping = {
      f = function()
        hop.hint_char1({
          direction = directions.AFTER_CURSOR,
          current_line_only = true,
        })
      end,
      F = function()
        hop.hint_char1({
          direction = directions.BEFORE_CURSOR,
          current_line_only = true,
        })
      end,
      t = function()
        hop.hint_char1({
          direction = directions.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end,
      T = function()
        hop.hint_char1({
          direction = directions.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1,
        })
      end,
    }

    for _, key in pairs(plugin.keys) do
      vim.keymap.set("n", key[1], mapping[key[1]], { remap = true })
    end
  end,
}
