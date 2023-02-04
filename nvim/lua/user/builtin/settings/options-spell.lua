-- HELP: https://soooprmx.com/vim의-autocmd-이벤트들/

vim.opt.spell = false
-- vim.opt.spelllang = "en,en_us,cjk"
vim.opt.spelllang = "en_us,cjk"
vim.opt.spellcapcheck = ""

local is_spell_ft = function(ft)
  if ft == nil then
    return false
  end

  for _, ft_nospell in pairs({
    "",
    "CHADTree",
    "help",
    "tagbar",
    "fstab",
    "checkhealth",
  }) do
    if ft == ft_nospell then
      return false
    end
  end

  return true
end

if vim.api.nvim_create_autocmd ~= nil then
  vim.api.nvim_create_autocmd(
    -- { "BufRead", "BufNewFile", "BufNew" },
    { "BufRead" },
    {
      pattern = { "*" },
      callback = function()
        if is_spell_ft(vim.opt_local.filetype:get()) then
          vim.opt_local.spell = true
        end
      end,
    }
  )
end
