if not require("utils").is_treesitter then
  return {
    [1] = "nvim-treesitter/nvim-treesitter",
    enabled = false,
  }
end

---@type LazySpec
local M = {
  [1] = "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  enabled = true,
  event = { "VeryLazy" }, -- { "BufReadPost", "BufNewFile" },
  init = function() end,
  opts = {
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
      -- disable = function(lang, buf)
      --   vim.notify(lang)
      --   local max_filesize = 100 * 1024 -- 100 KB
      --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      --   if ok and stats and stats.size > max_filesize then
      --     return true
      --   end
      -- end,
    },
    indent = {
      enable = true, -- NOTE: experimental features <2023-11-23>
    },
    incremental_selection = {
      enale = false,
    },
  },
  main = "nvim-treesitter.configs",
  config = function(plugin, opts)
    require("state.treesitter-langs"):add(
      --
      "diff",
      "comment",
      "dot",
      "regex",
      --
      "awk",
      "jq",
      --
      "ssh_config",
      "gpg",
      "udev"
    )
    opts.ensure_installed = require("state.treesitter-langs"):get_list()
    require(plugin.main).setup(opts)

    local del_commands = {
      "TSEditQuery",
      "TSEditQueryUserAfter",
    }
    for _, command in ipairs(del_commands) do
      vim.api.nvim_del_user_command(command)
    end

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  end,
  specs = {
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = {
        {
          [1] = "ray-x/cmp-treesitter",
          dependencies = "nvim-treesitter/nvim-treesitter",
        },
      },
      opts = function(_, opts)
        table.insert(
          opts.sources,
          { name = "treesitter", group_index = 1, max_item_count = 8 }
        )
      end,
    },
  },
}

return M
