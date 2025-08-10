--[[
NOTE:
  Auto insert bullets
]]
---@type LazySpec
return {
  [1] = "bullets-vim/bullets.vim",
  version = "*",
  lazy = false,
  cond = false,
  ft = { "markdown", "text", "gitcommit" },
  init = function(plugin)
    vim.g.bullets_line_spacing = 0
    -- vim.g.bullets_checkbox_markers = " /x"

    -- vim.g.bullets_enabled_file_types = plugin.ft
    vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }

    -- vim.g.bullets_set_mappings = 0
    -- vim.g.bullets_custom_mappings = {
    --   { "imap", "<cr>", "<Plug>(bullets-newline)" },
    --   { "inoremap", "<C-cr>", "<cr>" },
    --   { "nmap", "o", "<Plug>(bullets-newline)" },
    --   { "vmap", "grm", "<Plug>(bullets-renumber)" },
    --   { "nmap", "grm", "<Plug>(bullets-renumber)" },
    --   { "imap", "<C-t>", "<Plug>(bullets-demote)" },
    --   { "imap", "<C-d>", "<Plug>(bullets-promote)" },
    -- }
  end,
  -- keys = function(plugin, keys)
  --
  --   -- stylua: ignore
  --   return vim.list_extend(keys, {
  --     { "<CR>",  "<Plug>(bullets-newline)",  mode = "i", ft = plugin.ft },
  --     { "o",     "<Plug>(bullets-newline)",  mode = "n", ft = plugin.ft },
  --     { "<C-t>", "<Plug>(bullets-demote)",   mode = "i", ft = plugin.ft },
  --     { "<C-d>", "<Plug>(bullets-promote)",  mode = "i", ft = plugin.ft },
  --     { "grm",   "<Plug>(bullets-renumber)", mode = {"n", "v"}, ft = plugin.ft },
  --   })
  -- end,
}
