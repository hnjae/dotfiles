-- telescope
local prefix = require("var").prefix

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release"
        .. " && cmake --build build --config Release"
        .. " && cmake --install build --prefix build",
      cond = vim.fn.executable("cmake") == 1,
      module = true,
    },
    {
      "fhill2/telescope-ultisnips.nvim",
      dependencies = { "sirver/ultisnips" },
      module = true,
    },
  },
  lazy = true,
  cmd = {
    "Telescope"
  },
  keys = function()
    local t_builtin = require("telescope.builtin")
    local status_wk, wk = pcall(require, "which-key")
    if status_wk then
      wk.register({
        [prefix.fuzzy_finder] = { name = "+telescope" },
        [prefix.fuzzy_finder .. "h"] = { name = "+history" },
        [prefix.fuzzy_finder .. "G"] = { name = "+git" },
        [prefix.fuzzy_finder .. "S"] = { name = "+set" },
        [prefix.lang .. "t"] = { name = "+telescope-lsp" },
        [prefix.lang .. "ts"] = { name = "+telescope-lsp-symbols" },
      }, {})
    end

    --@type LazyKeys[]
    local lazykeys = {
      -- lazy load on following keys
      -- { prefix.lang .. "t", nil, desc = "+telescope-lsp" },
      -- replace default behavior
      { "<F1>", t_builtin.help_tags, desc = "help-tags" },
      { prefix.fuzzy_finder .. ":", t_builtin.commands, desc = "commands" },
      { prefix.fuzzy_finder .. "f", t_builtin.find_files, desc = "find-from-pwd" },
      { prefix.fuzzy_finder .. "b", t_builtin.buffers, desc = "buffers" },
      { prefix.fuzzy_finder .. "r", t_builtin.registrs, desc = "registers" },
      { prefix.fuzzy_finder .. "m", t_builtin.marks, desc = "marks" },
      { prefix.fuzzy_finder .. "l", t_builtin.current_buffer_fuzzy_find, desc = "line" },
      { prefix.fuzzy_finder .. "g", t_builtin.grep_string, desc = "rg-from-workspace" },
      { prefix.fuzzy_finder .. "j", t_builtin.jumplist, desc = "jumplist" },
      { prefix.fuzzy_finder .. "q", t_builtin.quickfix, desc = "quickfix" },
      { prefix.fuzzy_finder .. "hc", t_builtin.command_history, desc = "command" },
      { prefix.fuzzy_finder .. "hs", t_builtin.search_history, desc = "search" },
      { prefix.fuzzy_finder .. "hk", t_builtin.keymaps, desc = "keymaps" },
      { prefix.fuzzy_finder .. "hf", t_builtin.oldfiles, desc = "old-recent-file" },
      { prefix.fuzzy_finder .. "Gf", t_builtin.git_files, desc = "git-files" },
      { prefix.fuzzy_finder .. "Gc", t_builtin.git_commits, desc = "git-commits-pwd" },
      { prefix.fuzzy_finder .. "Gb", t_builtin.git_bcommits, desc = "git-commits-cur-buffer" },
      { prefix.fuzzy_finder .. "GB", t_builtin.git_branches, desc = "git-branches" },
      { prefix.fuzzy_finder .. "GB", t_builtin.git_status, desc = "git-status" },
      { prefix.fuzzy_finder .. "GB", t_builtin.git_stash, desc = "git-stash" },
      { prefix.fuzzy_finder .. "Sf", t_builtin.filetypes, desc = "filetypes" },
      { prefix.fuzzy_finder .. "Sh", t_builtin.highlights, desc = "highlights" },
      { prefix.fuzzy_finder .. "So", t_builtin.vim_options, desc = "vim-options" },
      { prefix.fuzzy_finder .. "Sa", t_builtin.autocommands, desc = "autocmd" },
      { prefix.fuzzy_finder .. "u", require("telescope").extensions.ultisnips.ultisnips, desc = "ultisnips" },
      { prefix.fuzzy_finder .. prefix.fuzzy_finder, "<cmd>Telescope<CR>", desc = "builtins" },
      --
      { prefix.lang .. "td", t_builtin.diagnostics, desc = "diagnostics" },
      { prefix.lang .. "tr", t_builtin.lsp_references, desc = "references" },
      { prefix.lang .. "ti", t_builtin.lsp_implementations, desc = "implementation" },
      { prefix.lang .. "tk", t_builtin.lsp_definitions, desc = "definition" },
      { prefix.lang .. "tt", t_builtin.lsp_type_definitions, desc = "type-definition" },
      { prefix.lang .. "tsd", t_builtin.lsp_document_symbols, desc = "document-symbols" },
      { prefix.lang .. "tsw", t_builtin.lsp_workspace_symbols, desc = "workspace-symbols" },
      { prefix.lang .. "tsW", t_builtin.lsp_dynamic_workspace_symbols, desc = "dynamic-workspace-symbols" },
      { prefix.lang .. "tst", t_builtin.treesitter, desc = "symbols-treesitter" },
      { prefix.lang .. "tsT", t_builtin.current_buffer_tags, desc = "symbols-tags" },
    }
    return lazykeys
  end,
  opts = {
    defaults = {},
    pickers = {
      -- TODO: use vim.fn.executable to find fd
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("ultisnips")
  end,
}
