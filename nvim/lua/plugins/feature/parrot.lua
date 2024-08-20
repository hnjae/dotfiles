-- WIP

-- local api_key = vim
--   .system({ "secret-tool", "lookup", "api", "openapi" }, { text = true })
--   :wait().stdout

---@type LazySpec
return {
  [1] = "frankroeder/parrot.nvim",
  enabled = false,
  dependencies = {
    -- "ibhagwan/fzf-lua" -- 이게 없어도 vim.select 로 내가 설정한 picker 로 작동
    "nvim-lua/plenary.nvim",
  },
  lazy = true,
  event = "VeryLazy",
  -- cond = api_key ~= "",
  opts = function()
    return {
      providers = {
        openai = {
          -- api_key = api_key,
        },
      },
    }
  end,
}
