---@type LazySpec
return {
  [1] = "trouble.nvim",
  optional = true,
  opts = function()
    local group = vim.api.nvim_create_augroup("MdTroubleAutoOpen", {})

    -- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    --   pattern = "*/obsidian/**/*.md",
    --   callback = function()
    --     vim.cmd("Trouble symbols")
    --   end,
    --   group = group,
    --   desc = "Open trouble for Obsidian files",
    -- })

    vim.api.nvim_create_autocmd({ "LspAttach" }, {
      pattern = "*/obsidian/**/*.md",
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client ~= nil and not client:supports_method("textDocument/documentSymbol") then
          return
        end

        vim.cmd("Trouble symbols")
      end,
      group = group,
      desc = "Open trouble for Obsidian files",
    })

    -- vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
    --   pattern = "*.md",
    --   callback = function()
    --     vim.cmd("Trouble symbols close")
    --   end,
    --   group = group,
    --   desc = "Close trouble for markdown files",
    -- })
  end,
}
