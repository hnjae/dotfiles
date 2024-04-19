return {
  -- shows indent line
  [1] = "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  enabled = true,
  cond = require("utils").enable_icon,
  event = { "VeryLazy" },
  main = "ibl",
  opts = function()
    local ret = {
      -- debounce = 400, -- default 200
      indent = {
        -- char = "▎", -- default left one quarter block (U+258E)
        char = "▏",
        -- char = "",
      },
      whitespace = {
        remove_blankline_trail = false,
      },
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = {
          "dashboard",
          "text",
          -- 
        },
      },
    }

    if vim.fn.hlexists("IndentBlanklineChar") == 1 then
      -- default: IblIndent
      ret.indent.highlight = "IndentBlanklineChar"
    end

    return ret
  end,
}
