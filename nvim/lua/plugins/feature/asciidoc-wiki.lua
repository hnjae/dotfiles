local dir_ = vim.fn.getenv("HOME") .. "/Projects/asciidoc-wiki.nvim"

return {
  dir = dir_,
  enabled = vim.loop.fs_stat(dir_) ~= nil,
  name = "asciidoc-wiki",
  -- dev = true,
  opts = {
    wiki_list = {
      {
        path = "~/Documents/wiki",
      },
      {
        path = "~/Documents/wiki_test",
      },
    },
    conceal_links = true,
    key_mappings = { prefix = "s", buffer = true },
  },
  config = function(_, opts)
    local wiki = require("asciidoc-wiki")
    local wiki_link = require("asciidoc-wiki.link")
    wiki.setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "asciidoc", "asciidoctor" },
      callback = function()
        vim.keymap.set({ "n" }, "CR", wiki_link.follow_link, { desc = "follow-wiki-link", buffer = true })
      end,
    })
  end,
}
