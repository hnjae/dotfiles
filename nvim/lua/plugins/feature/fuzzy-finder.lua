-- telescope
local val = require("val")
local prefix = val.prefix
local map_keyword = val.map_keyword

return {
  [1] = "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      [1] = "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = vim.fn.executable("make") == 1 and vim.fn.executable("cc") == 1,
      module = true,
    },
    {
      -- replace vim.ui.select with telescope
      [1] = "nvim-telescope/telescope-ui-select.nvim",
      module = true,
    },
    {
      [1] = "benfowler/telescope-luasnip.nvim",
      module = true,
    },
  },
  lazy = true,
  -- TODO: find appropriate event that calls vim.ui.select()
  event = { "CmdLineEnter", "MenuPopup" },
  cmd = {
    "Telescope",
  },
  keys = function()
    local t_builtin = require("telescope.builtin")
    local _, lspconfig = pcall(require, "lspconfig")

    local find_project_root = lspconfig.util.root_pattern(unpack(val.root_patterns))

    ---@type LazyKeysSpec[]
    local lazykeys = {
      {
        [1] = prefix.finder .. map_keyword.snippet,
        [2] = nil,
        desc = "luasnip",
      },
      -- { [1] = "g" .. "l",                             [2] = t_builtin.current_buffer_tags, desc = "telescope-symbols (tags)" },

      -- replace default behavior
      {
        [1] = "<F1>",
        [2] = t_builtin.help_tags,
        desc = "help-tags",
      },

      --
      {
        [1] = prefix.finder .. map_keyword.marks,
        [2] = t_builtin.marks,
        desc = "marks",
      },
      {
        [1] = prefix.finder .. "0",
        [2] = "<cmd>Telescope<CR>",
        desc = "builtins",
      },
      {
        [1] = prefix.finder .. map_keyword.marks,
        [2] = t_builtin.marks,
        desc = "telescope-marks",
      },
      {
        [1] = prefix.finder .. map_keyword.line,
        [2] = t_builtin.current_buffer_fuzzy_find,
        desc = "telescope-line",
      },
      {
        [1] = prefix.finder .. map_keyword.symbols,
        [2] = t_builtin.treesitter,
        desc = "telescope-symbols (treesitter)",
      },
      {
        [1] = prefix.finder .. string.upper(map_keyword.symbols),
        [2] = t_builtin.lsp_document_symbols,
        desc = "telescope-symbols (lsp)",
      },

      --
      {
        [1] = prefix.finder .. ":",
        [2] = t_builtin.commands,
        desc = "commands",
      },
      {
        [1] = prefix.finder .. "R",
        [2] = t_builtin.registers,
        desc = "registers",
      },
      {
        [1] = prefix.finder .. "q",
        [2] = t_builtin.quickfix,
        desc = "quickfix",
      },

      -- +history
      {
        [1] = prefix.finder .. "h",
        [2] = nil,
        desc = "+history",
      },
      {
        [1] = prefix.finder .. "hc",
        [2] = t_builtin.command_history,
        desc = "command-history",
      },
      {
        [1] = prefix.finder .. "hs",
        [2] = t_builtin.search_history,
        desc = "search-history",
      },
      {
        [1] = prefix.finder .. "hk",
        [2] = t_builtin.keymaps,
        desc = "keymaps-history",
      },
      {
        [1] = prefix.finder .. "hf",
        [2] = t_builtin.oldfiles,
        desc = "oldfiles-history",
      },
      {
        [1] = prefix.finder .. "hn",
        [2] = nil,
        desc = "notify-history",
      },

      -- git
      {
        [1] = prefix.finder .. "Gf",
        [2] = t_builtin.git_files,
        desc = "git-files",
      },
      {
        [1] = prefix.finder .. "Gc",
        [2] = t_builtin.git_commits,
        desc = "git-commits-pwd",
      },
      {
        [1] = prefix.finder .. "Gb",
        [2] = t_builtin.git_bcommits,
        desc = "git-commits-cur-buffer",
      },
      {
        [1] = prefix.finder .. "GB",
        [2] = t_builtin.git_branches,
        desc = "git-branches",
      },
      {
        [1] = prefix.finder .. "GB",
        [2] = t_builtin.git_status,
        desc = "git-status",
      },
      {
        [1] = prefix.finder .. "GB",
        [2] = t_builtin.git_stash,
        desc = "git-stash",
      },

      -- telescope
      {
        [1] = prefix.lang .. "t",
        [2] = nil,
        desc = "+telescope",
      },
      {
        [1] = prefix.lang .. "td",
        [2] = t_builtin.diagnostics,
        desc = "diagnostics",
      },
      {
        [1] = prefix.lang .. "tr",
        [2] = t_builtin.lsp_references,
        desc = "references",
      },
      {
        [1] = prefix.lang .. "ti",
        [2] = t_builtin.lsp_implementations,
        desc = "implementation",
      },
      {
        [1] = prefix.lang .. "tk",
        [2] = t_builtin.lsp_definitions,
        desc = "definition",
      },
      {
        [1] = prefix.lang .. "tt",
        [2] = t_builtin.lsp_type_definitions,
        desc = "type-definition",
      },
    }

    local base_presets = {
      {
        key = "f",
        desc = "find-files",
        func = function()
          t_builtin.find_files({
            cwd = find_project_root(vim.fn.expand("%:p:h")),
          })
        end,
      },
      {
        key = "b",
        desc = "buffers",
        func = t_builtin.buffers,
      },
      {
        key = "r",
        desc = "rg",
        func = function()
          -- t_builtin.grep_string({ use_regex = true })
          t_builtin.grep_string({
            cwd = find_project_root(vim.fn.expand("%:p:h")),
          })
        end,
      },
    }

    for _, preset in pairs(base_presets) do
      local new_keysets = {
        {
          [1] = prefix.finder .. preset.key,
          [2] = preset.func,
          desc = preset.desc,
        },
        {
          [1] = prefix.split .. preset.key,
          [2] = function()
            vim.cmd([[
            split
            Alpha
            ]])
            preset.func()
          end,
          desc = preset.desc,
        },
        {
          [1] = prefix.vsplit .. preset.key,
          [2] = function()
            vim.cmd([[
            vsplit
            Alpha
            ]])
            preset.func()
          end,
          desc = preset.desc,
        },
        {
          [1] = prefix.tab .. preset.key,
          [2] = function()
            vim.cmd([[
            tab split
            Alpha
            ]])
            preset.func()
          end,
          desc = preset.desc,
        },
      }
      -- table.insert(lazykeys0, )
      for _, keysets in pairs(new_keysets) do
        table.insert(lazykeys, keysets)
      end
    end

    return lazykeys
  end,
  opts = function()
    local opts = {
      defaults = {},
      pickers = {
        find_files = {
          find_command = {
            "fd",
            "--hidden",
            -- "--type",
            -- "f",
            "--strip-cwd-prefix",
            -- "--ignore-vcs",
            "-E",
            ".git",
            "-E",
            ".direnv",
          },
        },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
      },
    }

    return opts
  end,
  ---@type fun(LazyPlugin, opts: table)
  config = function(plugin, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    local rhs_mapping = {
      luasnip = require("telescope").extensions.luasnip.luasnip,
      notify = require("telescope").extensions.notify.notify,
    }

    for _, key in pairs(plugin.keys()) do
      if key[2] == nil and rhs_mapping[key.desc] ~= nil then
        vim.keymap.set("n", key[1], rhs_mapping[key.desc], { desc = key.desc })
      end
    end
  end,
}
