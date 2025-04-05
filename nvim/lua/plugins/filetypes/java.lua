require("plugins.core.treesitter.languages"):add("java")

---@type LazySpec
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("plugins.core.treesitter.languages"):add("java")
    end,
  },
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   enable = false and vim.fn.executable("jdt-language-server") == 1,
  --   lazy = false,
  --   -- opts = function()
  --   -- end,
  --   config = function()
  --     -- local opts = {
  --     --   cmd = { "jdt-language-server" },
  --     --   -- root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
  --     -- }
  --     -- require("jdtls").start_or_attach(opts)
  --   end,
  -- },
}
