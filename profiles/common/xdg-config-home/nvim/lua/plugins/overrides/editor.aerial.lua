local icons = require("globals").icons
local strip = function(str)
  return string.sub(str, 1, #str - 1)
end
-- LazyVim's `editor.aerial`

---@type LazySpec[]
return {
  {
    [1] = "aerial.nvim",
    optional = true,
    opts = {
      backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
      lazy_load = false, -- lazy_load is being managed by lazy.nvim

      highlight_on_hover = true,
      autojump = true,

      layout = {
        max_width = { 29 }, -- default: 40, 0.2
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
        [1] = "<leader>cs",
        [2] = function()
          require("aerial").toggle({ focus = false })
        end,
        desc = "Aerial (Symbols)",
      },

      -- `gO` (vim.lsp.document_symbol)
      {
        [1] = "gO", -- default:
        [2] = function()
          require("aerial").open({ focus = true, direction = "float" })
        end,
        desc = "Aerial (Symbols)",
      },

      -- NOTE: `<cmd>Aeri` 이나 `:<C-u>Aeri` 로 맵핑하지 않는 이유는, `[count]AerialNext` 와 같이 사용하기 위함 <2025-04-23>
      -- mimic neovim's `[t`
      { [1] = "]t", [2] = ":AerialNext<CR>", desc = "symbol-next (aerial)", silent = true },
      { [1] = "[t", [2] = ":AerialPrev<CR>", desc = "symbol-prev (aerial)", silent = true },
    },
    specs = {
      {
        [1] = "mini.icons",
        optional = true,
        opts = {
          filetype = {
            aerial = { glyph = strip(icons.symbol), hl = "MiniIconsPurple" }, -- default: 󱘎
          },
        },
      },
    },
  },

  -- {
  --   [1] = "aerial.nvim",
  --   optional = true,
  --   opts = function()
  --     vim.api.nvim_create_autocmd("WinClosed", {
  --       callback = function(ev)
  --         -- NOTE:
  --         -- ev.buf: 닫힌 윈도우의 버퍼
  --
  --         if vim.api.nvim_get_option_value("buftype", { buf = ev.buf }) ~= "" then
  --           return
  --         end
  --
  --         -- HACK: 커서가 다른 윈도우에 포커스 되었다고 가정하기 위해 대기 <2025-04-22>
  --         vim.defer_fn(function()
  --           local buf = vim.api.nvim_get_current_buf()
  --           if vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "aerial" then
  --             return
  --           end
  --
  --           vim.cmd("quit")
  --
  --           -- 아래 두개로 제거하면 안됨
  --           -- require("snacks").bufdelete(buf)
  --           -- require("aerial").close()
  --         end, 5)
  --       end,
  --     })
  --   end,
  -- },
}
