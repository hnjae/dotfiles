-- TODO: consider replacing following with https://github.com/kylechui/nvim-surround  <2023-01-10, Hyunjae Kim>
-- TODO: consider replacing following with https://github.com/kylechui/nvim-surround  <2023-01-10, Hyunjae Kim>
return {
  [1] = "tpope/vim-surround",
  lazy = false,
  enabled = true,
  keys = {
    { [1] = "ys", [2] = nil, mode = { "n" }, desc = "Ysurround" },
    { [1] = "yS", [2] = nil, mode = { "n" }, desc = "YSurround" },
    { [1] = "Yss", [2] = nil, mode = { "n" }, desc = "Yssurround" },
    { [1] = "YSs", [2] = nil, mode = { "n" }, desc = "YSsurround" },
    { [1] = "YSS", [2] = nil, mode = { "n" }, desc = "YSsurround" },
  },
  config = function()
    -- vim.api.nvim_create_autocmd({ "FileType" }, {
    --   desc = "add `++` pattern to vim-surround",
    --   pattern = { "asciidoctor", "asciidoc" },
    --   callback = function()
    --     vim.b.surround_43 = "`+\r+`"
    --   end,
    -- })
  end,
}
