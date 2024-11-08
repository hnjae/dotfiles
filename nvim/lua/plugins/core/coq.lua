-- 2024-07-26.
-- 서드파티 스닛펫 엔진이랑 연동 안됨. 자체 snippet 엔진에 수동으로 스닛펫
-- 주가가 가능한지 모르겠음.
-- "pynvim_pp" "msgpack" "std2" "pyyaml" 의 4 가지 파이썬 패키지를 필요로 함

return {
  [1] = "ms-jpq/coq_nvim",
  enabled = false,
  lazy = true,
  event = { "InsertEnter", "CmdlineEnter" },
  init = function()
    vim.g.loaded_python3_provider = 1
    vim.g.coq_settings = {
      auto_start = true, -- if you want to start COQ at startup
      -- Your COQ settings here
    }
    -- vim.g.coq_settings["display.icons.mode"] =
  end,
  config = function() end,
  specs = {
    {
      [1] = "neovim/nvim-lspconfig",
      optional = true,
      ---@param opts myLspconfigOpts
      opts = function(_, opts)
        opts.default_capabilities =
          require("coq").lsp_ensure_capabilities().capabilities
      end,
    },
  },
}
