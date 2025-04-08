--[[
  Comment.nvim:
    - it supports dot-repeat
    - :h comment-nvim
    - which-key.nvim complains key conflict:
      - https://github.com/folke/which-key.nvim/issues/218#issuecomment-1890858022
      - https://github.com/numToStr/Comment.nvim/issues/167

  neovim's built-in commenting:
    - `:h commenting`
    - neovim 빌트인은 `gb` 같은 키맵을 제공하지 않는다.
    - <https://github.com/neovim/neovim/pull/28176>
]]

---@type LazySpec
return {
  [1] = "numToStr/Comment.nvim",
  lazy = true,
  enabled = true,
  dependencies = {
    {
      [1] = "JoosepAlviste/nvim-ts-context-commentstring",
      optional = true,
    },
  },
  opts = function()
    local res = {
      mappings = false,
    }

    local is_ts_context, ts_context = pcall(require, "ts_context_commentstring.integrations.comment_nvim")

    if is_ts_context then
      res.pre_hook = ts_context.create_pre_hook()
    end

    return res
  end,
  keys = {
    -- NOTE: `gb` 맵핑만 사용.
    {
      [1] = "gb",
      [2] = "<Plug>(comment_toggle_blockwise)",
      desc = "comment-toggle-blockwise",
      mode = "n",
    },
    {
      [1] = "gb",
      [2] = "<Plug>(comment_toggle_blockwise_visual)",
      desc = "comment-toggle-blockwise (visual)",
      mode = "x",
    },
    {
      [1] = "gbc",
      [2] = function()
        return vim.api.nvim_get_vvar("count") == 0 and "<Plug>(comment_toggle_blockwise_current)"
          or "<Plug>(comment_toggle_blockwise_count)"
      end,
      desc = "comment-toggle-current-block",
      expr = true,
      mode = "n",
    },
    -- NOTE: `gc` 맵핑은 사용하지 않음. neovim 빌트인 커맨드에서 사용하기 위해.
    --[[ {
      [1] = "gc",
      [2] = "<Plug>(comment_toggle_linewise)",
      desc = "comment-toggle-linewise",
      mode = "n",
    },
    {
      [1] = "gc",
      [2] = "<Plug>(comment_toggle_blockwise_linewise)",
      desc = "comment-toggle-linewise (visual)",
      mode = "x",
    },
    {
      [1] = "gcc",
      [2] = function()
        return vim.api.nvim_get_vvar("count") == 0
            and "<Plug>(comment_toggle_linewise_current)"
          or "<Plug>(comment_toggle_linewise_count)"
      end,
      desc = "comment-toggle-current-line",
      expr = true,
      mode = "n",
    }, ]]
  },
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      ---@class opts wk.Opts
      opts = function(_, opts)
        local icon = "" -- nf-oct-comment
        local color = "grey"

        opts.icons = opts.icons or {}
        opts.icons.rules = opts.icons.rules or {}
        table.insert(opts.icons.rules, {
          plugin = "Comment.nvim",
          icon = icon,
          color = color,
        })

        -- neovim's built-in
        opts.spec = opts.spec or {}
        table.insert(opts.spec, {
          [1] = "gc",
          icon = { icon = icon, color = color },
          mode = { "n", "v" },
        })
      end,
    },
  },
}
