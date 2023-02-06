return {
  "phaazon/hop.nvim",
  branch = "v2",
  enabled = true,
  lazy = true,
  opts = {
    { keys = "etovxqpdygfblzhckisuran" },
  },
  keys = function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    --@type LazyKeys[]
    local lazykeys = {
      {
        "f",
        function()
          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end,
        remap = true,
      },
      {
        "F",
        function()
          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end,
        remap = true,
      },
      {
        "t",
        function()
          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
        end,
        remap = true,
      },
      {
        "T",
        function()
          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
        end,
        remap = true,
      },
    }

    return lazykeys
  end,
}
