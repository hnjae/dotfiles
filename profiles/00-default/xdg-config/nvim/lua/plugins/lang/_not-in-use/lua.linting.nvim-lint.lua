---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  opts = function(_, opts)
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.lua = vim.list_extend(opts.linters_by_ft.lua or {}, { "selene" })

    local root_pattern = require("lspconfig").util.root_pattern("selene.toml")

    local cwd = vim.api.nvim_buf_get_name(0)
    if cwd == "" then
      cwd = vim.uv.cwd()
    end

    -- TODO: dynamic update <2025-04-13>

    if cwd ~= nil then
      opts.linters = opts.linters or {}
      opts.linters.selene = vim.tbl_deep_extend("keep", opts.linters.selene or {}, {
        cwd = root_pattern(cwd),
      })
    end

    -- vim.api.nvim_create_autocmd({ "FileType" }, {
    --   pattern = { "lua" },
    --   callback = function(event)
    --     local checkstyle_config = vim.uv.cwd() .. "/checkstyle.xml"
    --     local has_checkstyle = vim.uv.fs_stat(checkstyle_config) and vim.fn.executable("checkstyle")
    --     local is_main = vim.api.nvim_buf_get_name(0):find("src/main/java") ~= nil
    --     if has_checkstyle and is_main then
    --       vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    --         buffer = event.buf,
    --         group = vim.api.nvim_create_augroup("checkstyle-" .. event.buf, { clear = true }),
    --         callback = function()
    --           if not vim.bo[event.buf].modified then
    --             require("lint.linters.checkstyle").config_file = checkstyle_config
    --             require("lint").try_lint("selene")
    --           end
    --         end,
    --       })
    --     end
    --   end,
    -- })
  end,
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "selene" } },
    },
  },
}
