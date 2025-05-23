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
            text = { "%s" },
            click = "v:lua.ScFa",
          },
          {
            text = { builtin.foldfunc },
            click = "v:lua.ScFa",
          },
          {
            text = { builtin.lnumfunc },
            click = "v:lua.ScSa",
          },
          { text = { " " } },
        },
      })
    end,
    init = function()
      vim.opt.sidescrolloff = 1
      vim.opt.signcolumn = "auto:1" -- NOTE: 1 이지만, column 은 2칸 차지.
      vim.opt.foldcolumn = "0"

      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        callback = function()
          vim.opt_local.foldcolumn = "auto:1"
        end,
      })
      vim.opt.fillchars = {
        -- foldopen = "·",
        foldopen = "",
        -- foldopen = "·",
        -- foldopen = "-",
        foldclose = "+",
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
}
