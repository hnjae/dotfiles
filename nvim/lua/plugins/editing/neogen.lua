-- annotation generator

local prefix = "<LocalLeader>n"

---@type LazySpec
return {
  [1] = "danymat/neogen",
  lazy = true,
  enabled = require("utils").is_treesitter,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "Neogen",
  },
  opts = {
    languages = {
      lua = {
        template = {
          annotation_convention = "emmylua",
        },
      },
      python = {
        template = {
          annotation_convention = "reST",
        },
      },
      rust = {
        template = {
          annotation_convention = "rustdoc",
        },
      },
      typescript = {
        template = {
          annotation_convention = "tsdoc",
        },
      },
      typescriptreact = {
        template = {
          annotation_convention = "tsdoc",
        },
      },
    },
    snippet_engine = "luasnip",
  },
  keys = function()
    return {
      {
        [1] = prefix .. "c",
        [2] = function()
          require("neogen").generate({
            type = "class",
          })
        end,
        desc = "neogen-class",
      },
      {
        [1] = prefix .. "m",
        [2] = function()
          require("neogen").generate({
            type = "func",
          })
        end,
        desc = "neogen-fun",
      },
      {
        [1] = prefix .. "t",
        [2] = function()
          require("neogen").generate({
            type = "type",
          })
        end,
        desc = "neogen-type",
      },
      {
        [1] = prefix .. "f",
        [2] = function()
          require("neogen").generate({
            type = "file",
          })
        end,
        desc = "neogen-file",
      },
    }
  end,
  config = true,
  specs = {
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      opts = function(_, opts)
        opts.icons = opts.icons or {}
        opts.icons.rules = opts.icons.rules or {}
        opts.spec = opts.spec or {}

        table.insert(opts.spec, {
          [1] = prefix,
          group = "neogen",
          ---@type wk.Icon
          icon = "󰏩", -- nf-md-paw
        })
      end,
    },
  },
}
