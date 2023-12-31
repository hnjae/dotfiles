local M = {}

-- NOTE
-- BufNewFile

-- BufReadPre
-- FileType
-- BufReadPost
-- BufRead - 파일을 열때가 아니면 생기지 않음.
-- BufEnter -- happens every buffer-enter
-- VimEnter
-- UiEnter

-- BufLeave
--
-- BufNew
-- BufNewFile

-- BufEnter -- happens every buffer-enter
-- BufAdd
-- VimEnter
-- UiEnter

local idx = 0
local Notify = require("notify")
function M.setup()
  for _, event in ipairs({
    "VimEnter",
    "BufEnter",
    -- "BufRead",
    "BufAdd",
    -- "FileType",
    "BufReadPost",
    "BufRead",
    "BufReadPre",
    -- "FileReadPost",
    -- "BufAdd",
    "BufNewFile",
    "BufNew",
    -- "InsertEnter",
    "UiEnter",
    -- "VeryLazy",
  }) do
    vim.api.nvim_create_autocmd({
      event,
    }, {
      -- pattern = { "*" },
      -- pattern = {"*wiki/*.md"},
      callback = function()
        Notify.notify(tostring(idx) .. ": " .. event, "INFO", {})
        idx = idx + 1
      end,
    })
  end

  vim.api.nvim_create_autocmd({
    "FileType",
  }, {
    pattern = { "lua" },
    -- pattern = {"*wiki/*.md"},
    callback = function()
      Notify.notify(tostring(idx) .. ": " .. "FileType", "INFO", {})
      idx = idx + 1
    end,
  })

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
