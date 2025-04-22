---@type LazySpec[]
return {
  {
    [1] = "luukvbaal/statuscol.nvim",
    lazy = false,
    version = false,
    event = { "VeryLazy" },
    -- dependencies = { "marks.nvim" },
    opts = function(_, opts)
      local builtin = require("statuscol.builtin")
      return vim.tbl_deep_extend("force", opts or {}, {
        setopts = true, -- setup `statuscolumn`
        relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set

        segments = {
          {
            text = { builtin.foldfunc },
            click = "v:lua.ScFa",
          },
          {
            click = "v:lua.ScFa", -- %@ click function label, applies to each text element
            hl = "FoldColumn", -- %# highlight group label, applies to each text element
            condition = { true }, -- table of booleans or functions returning a boolean
            sign = { -- table of fields that configure a sign segment
              name = { ".*" }, -- table of Lua patterns to match the legacy sign name against
              text = { ".*" }, -- table of Lua patterns to match the extmark sign text against
              namespace = { ".*" }, -- table of Lua patterns to match the extmark sign namespace against
              maxwidth = 1, -- maximum number of signs that will be displayed in this segment
              colwidth = 2, -- number of display cells per sign in this segment
              auto = false, -- boolean or string indicating what will be drawn when no signs
              -- matching the pattern are currently placed in the buffer.
              wrap = false, -- when true, signs in this segment will also be drawn on the
              -- virtual or wrapped part of a line (when v:virtnum != 0).
              fillchar = " ", -- character used to fill a segment with less signs than maxwidth
              fillcharhl = nil, -- highlight group used for fillchar (SignColumn/CursorLineSign if omitted)
              foldclosed = false, -- when true, show signs from lines in a closed fold on the first line
            },
          },
          {
            text = { builtin.lnumfunc },
            click = "v:lua.ScSa",
            -- fillcharhl = "Normal",
          },
          {
            text = { " " },
          },
          {
            click = "v:lua.ScFa", -- %@ click function label, applies to each text element
            hl = "Normal",
            condition = { true }, -- table of booleans or functions returning a boolean
            sign = {
              namespace = { "gitsigns" }, -- table of Lua patterns to match the extmark sign namespace against
              maxwidth = 1, -- maximum number of signs that will be displayed in this segment
              colwidth = 1, -- number of display cells per sign in this segment
              auto = false, -- boolean or string indicating what will be drawn when no signs
              wrap = false, -- when true, signs in this segment will also be drawn on the
              fillchar = " ", -- character used to fill a segment with less signs than maxwidth
              fillcharhl = "LineNr",
              foldclosed = false, -- when true, show signs from lines in a closed fold on the first line
            },
          },
        },
      })
    end,
    init = function()
      vim.opt.sidescrolloff = 1
      -- vim.opt.signcolumn = "auto:1" -- NOTE: 1 이지만, column 은 2칸 차지.
      vim.opt.signcolumn = "yes" -- NOTE: 1 이지만, column 은 2칸 차지.

      vim.opt.foldcolumn = "auto:1"
      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        callback = function()
          vim.api.nvim_set_hl(0, "SignColumn", { link = "Normal", force = true })
          vim.api.nvim_set_hl(0, "FoldColumn", { link = "LineNr", force = true })
        end,
      })

      vim.opt.fillchars = {
        foldopen = " ",
        foldclose = "▐",
        -- foldsep = "│", -- open fold middle marker
        -- eob = "~", -- empty lines at the end of a buffer
        -- fold = '·', -- or '-' filling 'foldtext'
        -- diff = '-', -- deleted lines of the 'diff' option

        foldsep = " ",
        fold = " ",
        diff = "╱",
        eob = " ",
      }

      vim.opt.numberwidth = 3 -- default 4
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
    opts = {
      signs = {
        add = { text = "▍" },
        change = { text = "▍" },
      },
      signs_staged = {
        add = { text = "▍" },
        change = { text = "▍" },
      },
    },
  },
}
