--[[
NOTE:
  - snacks.statuscolumn 이 조건 상관 없이 8 글자나 차치해서 대체 함. <LazyVim 14.14.0; 2025-04-22>
--]]

local gitsign_char = "┃"

---@type LazySpec[]
return {
  {
    [1] = "luukvbaal/statuscol.nvim",
    lazy = false,
    version = false,
    event = { "VeryLazy" },
    -- dependencies = { "LazyVim", "gruvbox.nvim" },
    opts = function(_, opts)
      local builtin = require("statuscol.builtin")
      return vim.tbl_deep_extend("force", opts or {}, {
        setopts = true, -- setup `statuscolumn`
        relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set

        segments = {
          {
            text = { "%s" },
            click = "v:lua.ScFa",
          },
          {
            text = { builtin.lnumfunc },
            click = "v:lua.ScSa",
          },
          {
            -- foldmarker 표시 및 padding 으로 역할
            text = { builtin.foldfunc },
            click = "v:lua.ScFa",
          },
        },
      })
    end,
    init = function()
      vim.opt.sidescrolloff = 1
      vim.opt.signcolumn = "auto:1" -- NOTE: 1 이지만, column 은 2칸 차지.
      vim.opt.foldcolumn = "0"

      vim.opt.numberwidth = 2 -- default 4
      vim.opt.foldcolumn = "1"

      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        callback = function()
          -- vim.api.nvim_set_hl(0, "SignColumn", { link = "Normal", force = true })
          vim.api.nvim_set_hl(0, "FoldColumn", { link = "LineNr", force = true })
          -- vim.api.nvim_set_hl(0, "FoldColumn", { link = "NonText", force = true })
        end,
      })

      vim.opt.fillchars = {
        -- foldopen = "·",
        foldopen = " ",
        -- foldclose = "+",
        foldclose = "▐",
        -- foldclose = "▩",
        -- foldopen = "·",
        -- foldopen = "-",
        -- foldsep = "│", -- open fold middle marker
        -- eob = "~", -- empty lines at the end of a buffer
        -- fold = '·', -- or '-' filling 'foldtext'
        -- diff = '-', -- deleted lines of the 'diff' option

        foldsep = " ",
        fold = " ",
        diff = "╱",
        eob = " ",
      }
    end,
  },
  {
    -- shows marks
    [1] = "chentoast/marks.nvim",
    lazy = true,
    version = false,
    event = { "VeryLazy" },
    opts = {
      default_mappings = false,
      -- NOTE: <2025-04-22>
      -- `:help `sign-priority`
      -- todo-comments: 8
      -- lsp: 12 (maybe)
      sign_priority = 13, -- default 10
      -- refresh_interval = 200, -- default 150
    },
  },
  {
    [1] = "gitsigns.nvim",
    optional = true,
    opts = {
      diff_opts = {
        vertical = true,
      },
      signs = {
        add = { text = gitsign_char },
        change = { text = gitsign_char },
      },
      signs_staged = {
        add = { text = gitsign_char },
        change = { text = gitsign_char },
      },
    },
  },
}
