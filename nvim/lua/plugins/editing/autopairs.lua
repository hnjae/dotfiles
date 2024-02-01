---@type LazySpec
return {
  {
    [1] = "windwp/nvim-autopairs",
    lazy = true,
    event = { "InsertEnter" },
    enabled = true, -- "jiangmiao/auto-pairs" 가 조금더 신뢰할 만 한 것 같다.
    -- dependencies = {
    --   "nvim-treesitter/nvim-treesitter",
    -- },
    opts = {
      -- disable_filetype = { "TelescopePrompt", "spectre_panel" },
      disable_in_macro = true, -- disable when recording or executing a macro
      disable_in_visualblock = true, -- disable when insert after visual block mode
      -- ignored_next_char = [=[[%w%%%'%[%"%.]]=],
      -- enable_moveright = true,
      -- enable_afterquote = true,  -- add bracket pairs after quote
      enable_check_bracket_line = false, --- check bracket in same line
      -- enable_bracket_in_quote = true, --
      -- break_undo = true, -- switch for basic rule break undo sequence
      check_ts = true, -- use treesitter
      map_cr = true, -- add indent when new line
      map_bs = true, -- delete paren if <BS>
      -- NOTE: <C-h> delete single char in insert mode <2023-03-02>
      map_c_h = true, -- Map the <C-h> key to delete a pair
      -- map_c_w = false, -- map <c-w> to delete a pair if possible

      -- NOTE: fast_wrap: wrap text with surrounding
      fast_wrap = {
        map = "<M-e>",
      },
    },
    config = function(_, opts)
      local nvim_autopairs = require("nvim-autopairs")
      -- local rule = require("nvim-autopairs.rule")
      nvim_autopairs.setup(opts)
      nvim_autopairs.add_rules({
        -- rule("`+", "+`", "asciidoctor"),
        -- rule("`+", "+`", "asciidoc"),
        -- rule("``", "``", "asciidoctor"),
        -- rule("``", "``", "asciidoc"),
        -- press % => %% only while inside a comment or string
        -- rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({'string','comment'})),
        -- rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({'function'}))
      })
      -- nvim_autopairs.remove_rule("`")
    end,
  },
  {
    [1] = "jiangmiao/auto-pairs",
    lazy = false,
    enabled = false,
    event = { "InsertEnter" },
    init = function()
      vim.g.AutoPairsShortcutToggle = ""
      -- vim.cmd([[
      -- " au FileType asciidoctor  let b:AutoPairs = AutoPairsDefine({'`+' : '+`'})
      -- au FileType asciidoctor  let b:AutoPairs = AutoPairsDefine({'``' : '``'})
      -- ]])
    end,
  },
}
