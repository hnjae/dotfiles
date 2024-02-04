-- telescope
local val = require("val")
local prefix = val.prefix
local map_keyword = val.map_keyword

local enable_fzf_native = function()
  return vim.fn.executable("make") == 1 and vim.fn.executable("cc") == 1
end

---@type LazySpec
return {
  [1] = "nvim-telescope/telescope.nvim",
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      [1] = "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = enable_fzf_native(),
    },
    {
      -- replace vim.ui.select with telescope
      [1] = "nvim-telescope/telescope-ui-select.nvim",
    },
    {
      [1] = "fhill2/telescope-ultisnips.nvim",
    },
  },
  lazy = true,
  -- TODO: find appropriate event that calls vim.ui.select()
  event = { "CmdLineEnter", "MenuPopup" },
  cmd = {
    "Telescope",
  },
  ---@type fun(LazyPlugin, opts: table): LazyKeysSpec[]
  keys = function()
    local t_builtin = require("telescope.builtin")
    local _, lspconfig = pcall(require, "lspconfig")

    local find_project_root =
      lspconfig.util.root_pattern(unpack(val.root_patterns))

    ---@type LazyKeysSpec[]
    local keys_buffer = {
      {
        [1] = prefix.buffer_finder .. map_keyword.snippet,
        [2] = require("telescope").extensions.ultisnips.ultisnips,
        desc = "snippet",
      },
      {
        [1] = prefix.buffer_finder .. map_keyword.marks,
        [2] = t_builtin.marks,
        desc = "marks",
      },
      {
        [1] = prefix.buffer_finder .. map_keyword.line,
        [2] = t_builtin.current_buffer_fuzzy_find,
        desc = "line",
      },
      {
        [1] = prefix.buffer_finder .. string.upper(map_keyword.symbols),
        [2] = t_builtin.treesitter,
        desc = "symbols (treesitter)",
      },
      {
        [1] = prefix.buffer_finder .. map_keyword.symbols,
        [2] = t_builtin.lsp_document_symbols,
        desc = "symbols (lsp)",
      },
    }

    ---@type LazyKeysSpec[]
    local keys = {
      -- replace default behavior
      {
        [1] = "<F1>",
        [2] = t_builtin.help_tags,
        desc = "help-tags",
      },
      {
        [1] = prefix.finder .. "0",
        [2] = "<cmd>Telescope<CR>",
        desc = "builtins",
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
        [2] = require("telescope").extensions.notify.notify,
        desc = "notify-history",
      },
    }

    local new_win_presets = {
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
        key = "F",
        desc = "find-files-cwd",
        func = function()
          t_builtin.find_files({
            cwd = vim.fn.expand("%:p:h"),
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
          t_builtin.live_grep({
            cwd = find_project_root(vim.fn.expand("%:p:h")),
          })
        end,
      },
      {
        key = "R",
        desc = "rg-cwd",
        func = function()
          -- t_builtin.grep_string({ use_regex = true })
          t_builtin.live_grep({
            cwd = vim.fn.expand("%:p:h"),
          })
        end,
      },
    }

    for _, preset in pairs(new_win_presets) do
      local new_keysets = {
        {
          [1] = prefix.finder .. preset.key,
          [2] = preset.func,
          desc = preset.desc,
        },
      }
      for _, keysets in pairs(new_keysets) do
        table.insert(keys, keysets)
      end
    end

    for _, keysets in pairs(keys_buffer) do
      table.insert(keys, keysets)
    end

    return keys
  end,
  opts = function()
    local opts = {
      defaults = {
        history = {
          path = require("plenary.path"):new(
            vim.fn.stdpath("state"),
            "treesitter-history"
          ).filename,
        },
        mappings = {
          i = {
            [string.format("<C-%s>", map_keyword.split)] = "select_horizontal",
            -- ["<C-x>"] = nil,
          },
          n = {
            -- [string.format("<C-%s>", map_keyword.split)] = "select_horizontal",
            -- ["<C-x>"] = nil,
          },
        },
      },
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
            "node_modules",
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
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    if enable_fzf_native() then
      telescope.load_extension("fzf")
    else
      vim.notify("treesitter: fzf-native module could not be installed.")
    end

    telescope.load_extension("ui-select")
    telescope.load_extension("ultisnips")
  end,
}
