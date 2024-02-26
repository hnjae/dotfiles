---@type LazySpec
return {
  [1] = "stevearc/conform.nvim",
  lazy = true,
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = function()
    local ret = {
      -- Define your formatters
      formatters_by_ft = {},
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    }

    for _, lang_conf in ipairs(require("plugins.lsp.utils.get_lang_confs")()) do
      if lang_conf.get_conform_opts then
        ret = vim.tbl_deep_extend("keep", ret, lang_conf.get_conform_opts())
      end
    end

    return ret
  end,
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_user_command("Format", function()
      require("conform").format({ async = true, filter = nil, bufnr = 0 })
    end, {})
  end,
  config = function(_, opts)
    require("conform").setup(opts)

    -- vim.keymap.set(
    --   "n",
    --   "==",
    --   function() end,
    --   { desc = "conform-format", buffer =  }
    -- )
    for _, lang_conf in ipairs(require("plugins.lsp.utils.get_lang_confs")()) do
      if lang_conf.post_conform_setup then
        lang_conf.post_conform_setup()
      end
    end
  end,
}
