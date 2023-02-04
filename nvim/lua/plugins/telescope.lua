-- telescope

local telescope_spec = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release"
          .. " && cmake --build build --config Release"
          .. " && cmake --install build --prefix build",
      cond = vim.fn.executable("cmake") == 1,
    },
    {
      "fhill2/telescope-ultisnips.nvim",
      dependencies = { "sirver/ultisnips" },
    },
  },
  lazy = true,
  keys = {
    -- lazy load on following keys
    { _MAPPING_PREFIX["fuzzy-finder"], nil, desc = "+telescope" },
    { _MAPPING_PREFIX["lang"] .. "t", nil, desc = "+telescope-lsp" },
    { "<F1>", nil, desc = "help-tags" },
  },
}

telescope_spec.config = function()
  local config = {
    defaults = {
      -- vimgrep_arguments = {
      --   "rg",
      --   "--color=never",
      --   "--no-heading",
      --   "--with-filename",
      --   "--line-number",
      --   "--column",
      --   "--smart-case",
      --   "--trim" -- add this value
      -- }
      -- theme = "dropdown"
    },
    pickers = {
      -- TODO: buffers doesn't show its content  <2022-06-16, Hyunjae Kim>
      -- buffers = {
      --   theme ="dropdown"
      -- TODO: use vim.fn.executable to find fd
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      },
    },
    -- TODO: Not working <2022-06-16, Hyunjae Kim>
    -- builtin.current_buffer_fuzzy_find({opts}) *telescope.builtin.current_buffer_fuzzy_find()*
    extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
      -- }
      -- please take a look at the readme of the extension you want to configure
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
    },
  }

  local telescope = require("telescope")
  telescope.setup(config)
  telescope.load_extension("fzf")
  telescope.load_extension("ultisnips")

  ------------------------------------------------------------------------------
  -- key mapping
  ------------------------------------------------------------------------------
  local wk = require("which-key")
  local t_builtin = require("telescope.builtin")

  -- replace default behavior
  vim.keymap.set("n", "<F1>", t_builtin.help_tags, { desc = "help-tags" })

  wk.register({
    name = "+telescope",
    [":"] = { t_builtin.commands, "commands" },

    ["f"] = { t_builtin.find_files, "find-from-pwd" },

    ["b"] = { t_builtin.buffers, "buffers" },
    ["r"] = { t_builtin.registers, "registers" },
    ["m"] = { t_builtin.registers, "marks" },
    -- ["fl"] = { t_builtin.loclist, "loclist" },

    ["l"] = { t_builtin.current_buffer_fuzzy_find, "line" },
    ["g"] = { t_builtin.grep_string, "rg-from-workspace" },
    ["B"] = { t_builtin.current_buffer_fuzzy_find, "current_buffer_fuzzy_find" },

    ["j"] = { t_builtin.builtin, "jumplist" },
    ["q"] = { t_builtin.quickfix, "quickfix" },

    ----------------------------------------------------------------------
    ["h"] = { name = "+history" },
    ["hc"] = { t_builtin.command_history, "command" },
    ["hs"] = { t_builtin.search_history, "search" },
    ["hq"] = { t_builtin.quickfixhistory, "quickfixhistory" },
    ["hk"] = { t_builtin.keymaps, "keymaps" },
    ["hf"] = { t_builtin.oldfiles, "old-recent-file" },

    ----------------------------------------------------------------------
    ["G"] = { name = "+git" },
    ["Gf"] = { t_builtin.git_files, "git-files" },
    ["Gc"] = { t_builtin.git_commits, "git-commits-pwd" },
    ["Gb"] = { t_builtin.git_bcommits, "git-commits-cur-buffer" },
    ["GB"] = { t_builtin.git_branches, "git-branches" },
    ["Gs"] = { t_builtin.git_status, "git-status" },
    ["GS"] = { t_builtin.git_stash, "git-gstash" },
    -------------------------------------
    ["S"] = { name = "+set" },
    ["Sf"] = { t_builtin.filetypes, "filetypes" },
    ["Sh"] = { t_builtin.highlights, "highlights" },
    ["So"] = { t_builtin.vim_options, "vim-options" },
    ["Sa"] = { t_builtin.autocommands, "autocmd" },
    ----------------------------------------------------------------------

    ["u"] = { telescope.extensions.ultisnips.ultisnips, "ext-ultisnips" },
    [_MAPPING_PREFIX["fuzzy-finder"]] = { "<cmd>Telescope<CR>", "builtins" },
  }, { prefix = _MAPPING_PREFIX["fuzzy-finder"], mode = "n" })

  wk.register({
    name = "+telescope-lsp",
    ["d"] = { t_builtin.diagnostics, "diagnostics" },
    ["r"] = { t_builtin.lsp_references, "references" },
    ["i"] = { t_builtin.lsp_implementations, "implementation" },
    ["k"] = { t_builtin.lsp_definitions, "definition" },
    ["t"] = { t_builtin.lsp_type_definitions, "type-definition" },
    ["s"] = { name = "+symbols" },
    ["sd"] = { t_builtin.lsp_document_symbols, "document-symbols" },
    ["sw"] = { t_builtin.lsp_workspace_symbols, "workspace-symbols" },
    ["sW"] = { t_builtin.lsp_workspace_symbols, "all-workspace-symbols" },
    ["st"] = { t_builtin.treesitter, "symbols-treesitter" },
    ["sT"] = { t_builtin.current_buffer_tags, "tags" },
  }, { prefix = _MAPPING_PREFIX["lang"] .. "t", mode = "n" })
end

return {
  telescope_spec,
}
