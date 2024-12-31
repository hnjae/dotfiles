-- alternative: "jiangmiao/auto-pairs"

---@type LazySpec
local M = {
  [1] = "windwp/nvim-autopairs",
  lazy = true,
  enabled = true,
  event = { "InsertEnter" },
  dependencies = {
    { [1] = "nvim-treesitter/nvim-treesitter", optional = true },
  },
  opts = {
    -- disable_filetype = { "TelescopePrompt", "spectre_panel" },
    disable_in_macro = true, -- disable when recording or executing a macro
    disable_in_visualblock = true, -- disable when insert after visual block mode
    disable_in_replace_mode = true,

    ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol

    -- enable_moveright = true,
    -- enable_afterquote = true,  -- add bracket pairs after quote
    enable_check_bracket_line = false, --- check bracket in same line
    -- enable_bracket_in_quote = true, --
    -- break_undo = true, -- switch for basic rule break undo sequence
    check_ts = require("utils").is_treesitter, -- use treesitter
    map_cr = true, -- add indent when new line
    map_bs = true, -- delete paren if <BS>
    -- NOTE: <C-h> delete single char in insert mode <2023-03-02>
    map_c_h = true, -- Map the <C-h> key to delete a pair
    -- map_c_w = false, -- map <c-w> to delete a pair if possible

    -- NOTE: fast_wrap: wrap text with surrounding
    fast_wrap = {
      -- map = "<M-e>",
    },
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    local Rule = require("nvim-autopairs.rule")

    npairs.remove_rule("`")
    -- remove single quotes
    npairs.get_rule("'")[1].not_filetypes = { "nix" }

    npairs.add_rules({
      Rule("`", "`", { "sh" }),
      Rule("`+", "+`", { "asciidoctor", "asciidoc" }),
      Rule("``", "``", { "asciidoctor", "asciidoc" }),
      -- Rule("''", "''", { "nix" }),

      -- press % => %% only while inside a comment or string
      -- rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({'string','comment'})),
      -- rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({'function'}))
    })
  end,
  ---@type LazySpec[]
  specs = {
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      opts = function()
        require("utils.plugin").on_load("nvim-cmp", function()
          require("cmp").event:on(
            "confirm_done",
            require("nvim-autopairs.completion.cmp").on_confirm_done()
          )
        end)
      end,
    },
  },
}

return M
