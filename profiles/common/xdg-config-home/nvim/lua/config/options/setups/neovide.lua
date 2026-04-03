if vim.g.neovide then
  vim.g.neovide_input_ime = true
  vim.o.guifont = "Monospace:h19"

  -- local function set_ime(args)
  --   if args.event:match("Enter$") then
  --     vim.g.neovide_input_ime = true
  --   else
  --     vim.g.neovide_input_ime = false
  --   end
  -- end
  --
  -- local ime_input = vim.api.nvim_create_augroup("neovide-ime-input", { clear = true })
  --
  -- vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  --   group = ime_input,
  --   pattern = "*",
  --   callback = set_ime,
  -- })
  --
  -- vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
  --   group = ime_input,
  --   pattern = "[/\\?]",
  --   callback = set_ime,
  -- })
end
