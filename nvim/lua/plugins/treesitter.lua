local is_orgmode, orgmode = pcall(require, "orgmode")

-- vim.cmd([[
-- syntax off
-- ]])

-- local fts = require("val").treesitter_fts
local opts = {
  ensure_installed = "all", --vim.fn.executable("nix") == 1 and {} or "all",
  highlight = {
    enable = true,
    -- additional_vim_regex_highlighting = false,
    -- disable = function(lang, buf)
    --   local max_filesize = 100 * 1024 -- 100 KB
    --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --   if ok and stats and stats.size > max_filesize then
    --     return true
    --   end
    -- end,
  },
  indent = {
    enable = true, -- -- NOTE: experimental features <2023-11-23>
  },
  incremental_selection = {
    enale = false,
  },
  -- auto_install = vim.fn.executable("nix") ~= 1 and vim.fn.executable("tree-sitter") == 1,
  -- rainbow = {
  --   enable = true,
  --   -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
  --   extended_mode = true,   -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
  --   max_file_lines = 10000, -- Do not enable for files with more than n lines, int
  -- },
}

local org_opts = {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "org" },
  },
  -- ensure_installed = { "org" },
}
  return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "mrjones2014/nvim-ts-rainbow", module = true },
    },
    build = "<cmd>TSUpdate<CR>",
    -- cond = vim.fn.executable("tree-sitter"),
    lazy = false,
    --enabled = vim.fn.executable("gcc"),
    -- ft = fts,
    -- event = { "BufReadPost", "BufNewFile" },
    opts = opts,
    config = function(_, opts_)
      -- make first paren fg_color
      -- local fg_color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("StatusLine")), "fg")
      -- vim.cmd('exec "hi rainbowcol1 guifg=' .. fg_color .. '"')
      -- vim.cmd("hi rainbowcol1 guifg='" .. fg_color .. "'")

      if is_orgmode then
        orgmode.setup_ts_grammar()
        opts_ = vim.tbl_deep_extend("force", {}, opts_, org_opts)
      end
      require("nvim-treesitter.configs").setup(opts_)
    end,
  }
