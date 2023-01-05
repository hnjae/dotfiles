local M = {}


-- NOTE
-- BufRead - 파일을 열때가 아니면 생기지 않음.

-- BufAdd
-- BufEnter -- happens every buffer-enter
-- BufLeave

local Notify = require("notify")
function M.setup()
  for _, event in ipairs({ 
    "VimEnter", "BufEnter"
  }) do
    vim.api.nvim_create_autocmd(
      {
        event
      }, {
        -- pattern = {"*wiki/*.md"},
        callback = function()
          Notify.notify(event .. os.date(), "INFO", {})
        end
      }
    )
  end

  -- vim.api.nvim_create_autocmd({
  --   "BufWritePre"
  -- }, {
  --   -- pattern = {"*wiki/*.md"},
  --   group = asciidoc_auto_id,
  --   pattern = { "*.adoc" },
  --   callback = last_modified
  -- })
end

return M
