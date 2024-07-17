---@type LazySpec
return {
  [1] = "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  enabled = true,
  cond = require("utils").is_treesitter,
  event = { "VeryLazy" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    textobjects = {
      move = {
        enable = true,
        set_jumps = true, -- ??
        goto_next_start = {
          -- override's vim default (`]m`: 동일 기능 수행)
          ["]m"] = { query = "@function.outer", desc = "@function.outer" },

          -- override's vim default (`]/`: 동일 기능 수행)
          ["]/"] = { query = "@comment.outer", desc = "@comment.outer" },
          ["]*"] = { query = "@comment.outer", desc = "@comment.outer" },

          -- override's vim default
          ["]]"] = { query = "@class.outer", desc = "@class.outer" },

          -- override's vim default (기존: misspelled)
          ["]s"] = { query = "@statement.outer", desc = "@statement.outer" },
        },
        goto_next_end = {
          ["]M"] = { query = "@function.outer", desc = "@function.outer" },
          ["]S"] = { query = "@statement.outer", desc = "@statement.outer" },
        },
        goto_previou_start = {
          ["[m"] = "@function.outer",
          ["[/"] = { query = "@comment.outer", desc = "@comment.outer" },
          ["[*"] = { query = "@comment.outer", desc = "@comment.outer" },
          ["[["] = { query = "@class.outer", desc = "@class.outer" },

          -- override's vim default (기존: misspelled)
          ["[s"] = { query = "@statement.outer", desc = "@statement.outer" },
        },
        goto_previou_end = {
          ["[M"] = { query = "@function.outer", desc = "@function.outer" },
          ["[S"] = { query = "@statement.outer", desc = "@statement.outer" },
        },
      },
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          --[[
          NOTE:  <2024-04-02>
          reserved keywords:
            b: ()
            ( or ): ()
            B: {}
            { or }: {}
            < or >: <>
            [ or ]: []
            ', ", `
            p: paragraph
            s: sentence
            t: tag
            w: word
            W: WORD
          ]]
          --

          -- stylua: ignore start
          -- sh, css, fish, go, js, lua, py, rs, ts, yaml
          ["as"] = { query = "@statement.outer",  desc = "@statement.outer" }, -- override sentence (won't override if not supported)
          ["aa"] = { query = "@assignment.outer", desc = "@assignment.outer" },
          ["ia"] = { query = "@assignment.inner", desc = "@assignment.inner" },
          ["la"] = { query = "@assignment.lhs",   desc = "@assignment.lhs" },
          ["ra"] = { query = "@assignment.rhs",   desc = "@assignment.rhs" },

          -- @comment.inner 는 잘 지원되지 않음.
          ["a/"] ={ query = "@comment.outer",  desc = "@comment.outer" },
          ["a*"] ={ query = "@comment.outer",  desc = "@comment.outer" },
          ["ac"] ={ query = "@comment.outer",  desc = "@comment.outer" },
          -- ["ic"] ={ query = "@comment.inner",  desc = "@comment.inner" },

          ["am"] = { query = "@function.outer",   desc = "@function.outer" },
          ["im"] = { query = "@function.inner",   desc = "@function.inner" },

          ["al"] = { query = "@loop.outer",       desc = "@loop.outer" },
          ["il"] = { query = "@loop.inner",       desc = "@loop.inner" },
          ["in"] = { query = "@number.inner",     desc = "@number.inner" },
          ["ip"] = { query = "@parameter.inner",  desc = "@parameter.inner" },
          ["ap"] = { query = "@parameter.outer",  desc = "@parameter.outer" },
          --
          ["aC"] = { query = "@class.outer",      desc = "@class.outer" },
          ["iC"] = { query = "@class.inner",      desc = "@class.inner" },
          --
          ["ax"] = { query = "@call.outer",       desc = "@call.outer" },
          ["ix"] = { query = "@call.inner",       desc = "@call.inner" },

          -- go, js, tex, lua, py, rs, ts
          ["ak"] = { query = "@block.outer",      desc = "@block.outer" },
          ["ik"] = { query = "@block.inner",      desc = "@block.inner" },

          -- stylua: ignore end
          -- ["ao"] = { query = "@conditional.outer", desc = "@conditional.outer" },
          -- ["io"] = { query = "@conditional.inner", desc = "@conditional.inner" },
        },
        -- You can choose the select mode (default is charwise 'v')
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
      },
    },
  },

  main = "nvim-treesitter.configs",
  config = function(plugin, opts)
    require(plugin.main).setup(opts)
    -- local ts_repeat_move =
    --   require("nvim-treesitter.textobjects.repeatable_move")

    -- -- Repeat movement with ; and ,
    -- -- ensure ; goes forward and , goes backward regardless of the last direction
    -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    -- vim.keymap.set(
    --   { "n", "x", "o" },
    --   ",",
    --   ts_repeat_move.repeat_last_move_previous
    -- )
    --
    -- -- vim way: ; goes to the direction you were moving.
    -- -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    -- -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    --
    -- -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    -- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    -- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    -- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    -- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
  end,
}
