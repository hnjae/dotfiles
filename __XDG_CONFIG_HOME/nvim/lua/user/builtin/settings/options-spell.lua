-- help: https://soooprmx.com/vim의-autocmd-이벤트들/

vim.opt.spell = true
vim.opt.spelllang = "en,en_us,cjk"
vim.opt.spellcapcheck = ""

-- vim.api.nvim_create_autocmd(
--   "FileType", {
--     pattern  = {"CHADTree"},
--     callback = vim.cmd([[setlocal nospell]])
--   }
-- )

    -- au TermOpen * setlocal list

local is_nospell_ft = function(ft)
  if ft == nil or ft == "" then
    return true
  end

  for _, ft_nospell in pairs({"CHADTree", "help", "tagbar", "fstab", "checkhealth"})  do
    if ft == ft_nospell then
      return true
    end
  end

  return false
end

if vim.api.nvim_create_autocmd ~= nil then
  vim.api.nvim_create_autocmd(
    {"BufRead", "BufNewFile", "BufNew"}, {
      pattern = {"*"},
      callback  = function ()
        if is_nospell_ft(vim.opt_local.filetype:get()) then
          vim.opt_local.spell = false
        end
      end
    }
  )
end
