local prefix = "<Leader>t"
local spec = {
  "akinsho/toggleterm.nvim",
  version = "2.3.x",
  lazy = true,
  cmd = {
    "ToggleTerm",
    "ToggleTermToggleAll",
    -- 'ToggleTermSetName',
  },
  -- event = { "CmdlineEnter" },
  opts = {
    open_mapping = [[<F4>]],
    shell = os.getenv("SHELL") or vim.o.shell,
    -- direction="horizontal",
  },
  keys = {
    { "<F4>", nil, desc = "toggleterm" },
    { prefix .. "l", "<cmd>ToggleTermSendCurrentLine<CR>", mode = { "n" }, desc = "send-line" },
    -- { prefix .. "b", ":<C-u>%>ToggleTermSendCurrentLine<CR>", mode = { "n" }, desc = "send-buffer" },
    { prefix .. "b", "<C-\\><C-n>ggVG:<C-u>'<,'>ToggleTermSendVisualLines<CR>", mode = { "n" }, desc = "send-buffer" },
    { prefix .. "l", ":<C-u>'<,'>ToggleTermSendVisualLines<CR>", mode = { "x" }, desc = "send-visual-lines" },
    { prefix .. "s", ":<C-u>'<,'>ToggleTermSendVisualSelection<CR>", mode = { "x" }, desc = "send-visual-selection" },
    -- TODO: visual 이랑 selectin 이랑 뭐가 달라? <2023-02-15>
    -- visual 에서 lazy 랑 같이 쓰려면 <cmd>로는 안된다.
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
  end,
}

return { spec }
