if vim.g.neovide then
  -- vim.g.neovide_input_ime = true
  -- vim.g.neovide_input_ime = true

  -- vim.o.guifont = "Monospace:h18"
  vim.o.guifont = "MesloLGM Nerd Font:h18"
  -- vim.opt.linespace = -3
  -- vim.g.neovide_scroll_animation_length = 0

  -- vim.g.neovide_transparency = 0.8
  -- vim.g.neovide_floating_blur_amount_x = 2.0
  -- vim.g.neovide_floating_blur_amount_y = 2.0

  local function set_ime(args)
    if args.event:match("Enter$") then
      vim.g.neovide_input_ime = true
    else
      vim.g.neovide_input_ime = false
    end
  end

  local ime_input = vim.api.nvim_create_augroup("neovide-ime-input", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = ime_input,
    pattern = "*",
    callback = set_ime,
  })

  vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    group = ime_input,
    pattern = "[/\\?]",
    callback = set_ime,
  })
end
