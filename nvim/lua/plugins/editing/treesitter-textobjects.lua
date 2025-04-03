---@type LazySpec
local plugin = {
  [1] = "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  event = { "VeryLazy" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function()
    local opts = {
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- ??
          goto_next_start = {
            -- override's vim default xvim builtin: `misspelled` wordx
            ["]s"] = { query = "@assignment.outer", desc = "@assignment.outer" },
          },
          goto_next_end = {
            -- override's vim default (vim builtin: `misspelled` word)
            ["]S"] = { query = "@assignment.outer", desc = "@assignment.outer" },
          },
          goto_previous_start = {
            -- override's vim default (vim builtin: `misspelled` word)
            ["[s"] = { query = "@assignment.outer", desc = "@assignment.outer" },
          },
          goto_previous_end = {
            -- override's vim default (vim builtin: `misspelled` word)
            ["[S"] = { query = "@assignment.outer", desc = "@assignment.outer" },
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

          --[[
            Not in use:
              05. @attribute.inner
              06. @attribute.outer
              17. @frame.inner (LaTeX only)
              18. @frame.outer (LaTeX only)
              @scopename.inner

              todo?
              @regex.inner
              @regex.outer
              @return.inner
              @return.outer
           ]]

          -- sh, css, fish, go, js, lua, py, rs, ts, yaml

          -- stylua: ignore start
            ["ae"] = { query = "@statement.outer", desc = "@statement.outer" },

            ["as"] = { query = "@assignment.outer", desc = "@assignment.outer" }, -- override sentence (won't override if not supported)
            ["is"] = { query = "@assignment.inner", desc = "@assignment.inner" },
            ["ls"] = { query = "@assignment.lhs",   desc = "@assignment.lhs" },
            ["rs"] = { query = "@assignment.rhs",   desc = "@assignment.rhs" },


            ["in"] = { query = "@number.inner",     desc = "@number.inner" },
            ["ir"] = { query = "@parameter.inner",  desc = "@parameter.inner" },
            ["ar"] = { query = "@parameter.outer",  desc = "@parameter.outer" },

            -- TODO: block, loop, conditional 을 묶을 수 없나? <2025-03-30>
            -- go, js, tex, lua, py, rs, ts
            ["ak"] = { query = "@block.outer",      desc = "@block.outer" },
            ["ik"] = { query = "@block.inner",      desc = "@block.inner" },
          },
          -- You can choose the select mode (default is charwise 'v')
          selection_modes = {
            -- ["@assignment.outer"] = "V", -- linewise
            -- ["@statement.outer"] = "V", -- linewise
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
        },
      },
    }

    local mapping = {
      o = {
        type = "loop",
      },
      n = {
        type = "conditional",
      },
      m = {
        type = "function", -- vim builtin `]m` 와 일치하기 위해, `f` 말고 `m`을 사용
      },
      x = {
        type = "call",
      },
      c = {
        type = "class",
      },
    }

    -- ts_type: e.g. function, loop, class
    local outer, inner
    for keyword, obj in pairs(mapping) do
      outer = {
        query = string.format("@%s.outer", obj.type),
        desc = string.format("@%s.outer", obj.type),
      }
      inner = {
        query = string.format("@%s.inner", obj.type),
        desc = string.format("@%s.inner", obj.type),
      }
      opts.textobjects.move.goto_next_start["]" .. keyword] = outer
      opts.textobjects.move.goto_next_end["]" .. string.upper(keyword)] = outer
      opts.textobjects.move.goto_previous_start["[" .. keyword] = outer
      opts.textobjects.move.goto_previous_end["[" .. string.upper(keyword)] =
        outer
      opts.textobjects.select.keymaps["a" .. keyword] = outer
      opts.textobjects.select.keymaps["i" .. keyword] = inner
    end

    local big_ts_txt_obj = {
      query = { "@class.outer", "@function.outer", "@block.outer" },
      desc = "@{class,function,block}.outer",
    }
    -- override's vim default
    opts.textobjects.move.goto_next_start["]]"] = big_ts_txt_obj
    opts.textobjects.move.goto_next_end["]}"] = big_ts_txt_obj
    opts.textobjects.move.goto_previous_start["[["] = big_ts_txt_obj
    opts.textobjects.move.goto_previous_end["[{"] = big_ts_txt_obj

    -- @comment.inner 는 잘 지원되지 않음. vim builtin 와 일치하기 위해 `*`, `/` 사용
    local comment_ts_txt_obj =
      { query = "@comment.outer", desc = "@comment.outer" }
    -- override's vim default (`]/`: 동일 기능 수행)
    opts.textobjects.move.goto_next_start["]/"] = comment_ts_txt_obj
    opts.textobjects.move.goto_next_end["]*"] = comment_ts_txt_obj
    opts.textobjects.move.goto_previous_start["[/"] = comment_ts_txt_obj
    opts.textobjects.move.goto_previous_end["[*"] = comment_ts_txt_obj
    opts.textobjects.select.keymaps["a/"] = comment_ts_txt_obj
    opts.textobjects.select.keymaps["i/"] = comment_ts_txt_obj

    return opts
  end,

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

return {
  [1] = "nvim-treesitter/nvim-treesitter",
  optional = true,
  specs = {
    plugin,
  },
}
