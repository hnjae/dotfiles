M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.buf

      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_user_command("LspFormat", function()
          vim.lsp.buf.format({ bufnr = buffer, id = client.id })
        end, {})
      end
    end,
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    desc = "Lsp Config",
  })
end

return M
