-- telescope
local prefix = require("val").prefix

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
      -- replace vim.ui.select with telescope
      "nvim-telescope/telescope-ui-select.nvim",
      module = true,
    },
    {
      "benfowler/telescope-luasnip.nvim",
      module = true,
    },
    -- {
    --   "fhill2/telescope-ultisnips.nvim",
    --   dependencies = { "sirver/ultisnips" },
    --   module = true,
    -- },
  },
  lazy = true,
  -- TODO: find appropriate event that calls vim.ui.select()
  event = { "CmdLineEnter", "MenuPopup" },
  cmd = {
    "Telescope",
  },
  keys = function()
    local t_builtin = require("telescope.builtin")

    --@type LazyKeys[]
    local lazykeys = {
      -- lazy load on following keys
      -- { prefix.lang .. "t", nil, desc = "+telescope-lsp" },
      -- replace default behavior
      { "<F1>", t_builtin.help_tags, desc = "help-tags" },
      { prefix.finder .. ":", t_builtin.commands, desc = "commands" },
      { prefix.finder .. "f", t_builtin.find_files, desc = "find-from-pwd" },
      { prefix.finder .. "b", t_builtin.buffers, desc = "buffers" },
      { prefix.finder .. "r", t_builtin.registrs, desc = "registers" },
      { prefix.finder .. "m", t_builtin.marks, desc = "marks" },
      { prefix.finder .. "l", t_builtin.current_buffer_fuzzy_find, desc = "line" },
      {
        prefix.finder .. "g",
        t_builtin.grep_string,
        desc = "rg-from-workspace",
      },
      { prefix.finder .. "j", t_builtin.jumplist, desc = "jumplist" },
      { prefix.finder .. "q", t_builtin.quickfix, desc = "quickfix" },

      { prefix.finder .. "hc", t_builtin.command_history, desc = "command" },
      { prefix.finder .. "hs", t_builtin.search_history, desc = "search" },
      { prefix.finder .. "hk", t_builtin.keymaps, desc = "keymaps" },
      { prefix.finder .. "hf", t_builtin.oldfiles, desc = "old-recent-file" },
      { prefix.finder .. "hn", nil, desc = "notify" },

      { prefix.finder .. "Gf", t_builtin.git_files, desc = "git-files" },
      { prefix.finder .. "Gc", t_builtin.git_commits, desc = "git-commits-pwd" },
      {
        prefix.finder .. "Gb",
        t_builtin.git_bcommits,
        desc = "git-commits-cur-buffer",
      },
      { prefix.finder .. "GB", t_builtin.git_branches, desc = "git-branches" },
      { prefix.finder .. "GB", t_builtin.git_status, desc = "git-status" },
      { prefix.finder .. "GB", t_builtin.git_stash, desc = "git-stash" },
      { prefix.finder .. "Sf", t_builtin.filetypes, desc = "filetypes" },
      { prefix.finder .. "Sh", t_builtin.highlights, desc = "highlights" },
      { prefix.finder .. "So", t_builtin.vim_options, desc = "vim-options" },
      { prefix.finder .. "Sa", t_builtin.autocommands, desc = "autocmd" },
      -- { prefix.fuzzy_finder .. "u", require("telescope").extensions.ultisnips.ultisnips, desc = "ultisnips" },
      { prefix.finder .. "l", nil, desc = "luasnip" },
      { prefix.finder .. prefix.finder, "<cmd>Telescope<CR>", desc = "builtins" },
      --
      { prefix.lang .. "td", t_builtin.diagnostics, desc = "diagnostics" },
      { prefix.lang .. "tr", t_builtin.lsp_references, desc = "references" },
      { prefix.lang .. "ti", t_builtin.lsp_implementations, desc = "implementation" },
      { prefix.lang .. "tk", t_builtin.lsp_definitions, desc = "definition" },
      { prefix.lang .. "tt", t_builtin.lsp_type_definitions, desc = "type-definition" },
      {
        prefix.lang .. "tsd",
        t_builtin.lsp_document_symbols,
        desc = "document-symbols",
      },
      {
        prefix.lang .. "tsw",
        t_builtin.lsp_workspace_symbols,
        desc = "workspace-symbols",
      },
      {
        prefix.lang .. "tsW",
        t_builtin.lsp_dynamic_workspace_symbols,
        desc = "dynamic-workspace-symbols",
      },
      {
        prefix.lang .. "tst",
        t_builtin.treesitter,
        desc = "symbols-treesitter",
      },
      { prefix.lang .. "tsT", t_builtin.current_buffer_tags, desc = "symbols-tags" },
    }
    return lazykeys
  end,
  opts = function()
    local opts = {
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
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
      },
    }

    return opts
  end,
  config = function(plugin, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("luasnip")

    -- local status_wk, wk = pcall(require, "which-key")
    -- if status_wk then
    --   wk.register({
    --     [prefix.finder .. "h"] = { name = "+history" },
    --     [prefix.finder .. "G"] = { name = "+git" },
    --     [prefix.finder .. "S"] = { name = "+set" },
    --     [prefix.lang .. "t"] = { name = "+telescope-lsp" },
    --     [prefix.lang .. "ts"] = { name = "+telescope-lsp-symbols" },
    --   }, {})
    -- end

    local rhs_mapping = {
      luasnip = require("telescope").extensions.luasnip.luasnip,
      notify = require('telescope').extensions.notify.notify,
    }

    for _, key in pairs(plugin.keys) do
      if key[2] == nil and rhs_mapping[key.desc] ~= nil then
        vim.keymap.set("n", key[1], rhs_mapping[key.desc], { desc = key.desc })
      end
    end
  end,
}
