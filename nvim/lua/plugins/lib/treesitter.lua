local is_orgmode, orgmode = pcall(require, "orgmode")

local opts = {
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = { "vimdoc" },
    -- additional_vim_regex_highlighting = false,
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
}

local org_opts = {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "org" },
  },
}

return {
  [1] = "nvim-treesitter/nvim-treesitter",
  build = "<cmd>TSUpdate<CR>",
  lazy = true,
  event = { "VeryLazy" },
  -- event = { "BufReadPost", "BufNewFile" },
  opts = opts,
  config = function(_, opts_)
    if is_orgmode then
      orgmode.setup_ts_grammar()
      opts_ = vim.tbl_deep_extend("force", {}, opts_, org_opts)
    end
    require("nvim-treesitter.configs").setup(opts_)
  end,
}
