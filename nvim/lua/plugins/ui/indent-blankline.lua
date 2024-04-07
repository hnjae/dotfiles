return {
  -- shows indent line
  [1] = "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  enabled = true,
  cond = not require("utils").is_console,
  event = { "VeryLazy" },
  main = "ibl",
  opts = function()
    local ret = {
      indent = {},
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
