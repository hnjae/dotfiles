---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      ---@param opts wk.Opts
      opts = function(_, opts)
        local wk_icon = {
          icon = "󰑮 ", -- nf-md-run_fast (from overseer.nvim)
          color = "blue",
        }

        opts.icons = opts.icons or {}
        opts.icons.rules = opts.icons.rules or {}
        table.insert(opts.icons.rules, {
          plugin = "overseer.nvim",
          icon = wk_icon.icon,
          color = wk_icon.color,
        })

        opts.spec = opts.spec or {}
        table.insert(opts.spec, {
          [1] = "<Leader>o",
          group = "overseer",
          mode = { "n" },
          icon = wk_icon,
        })
      end,
    },
  },
}
