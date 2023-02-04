-- $XDG_CONFIG_HOME/nvim/init.lua

_MAPPING_PREFIX = {
  ["lang"] = "s",
  ["tab"] = "<Leader>nt",
  ["edit"] = "<Leader>ne",
  ["window"] = "<Leader>nw",
  ["sidebar"] = "<Leader>s",
  ["open"] = "<F6>",
  ["fuzzy-finder"] = "<F3>",
}

require("user.builtin").setup()
require("setup-lazy")
require("user.autocmd").setup()
require("fcitx").setup()

local status_wk, wiki = pcall(require, "asciidoc-wiki")
if status_wk then
  wiki.setup({
    wiki_list = {
      {
        path = "~/Sync/Library/wiki",
      },
      {
        path = "~/Sync/Library/hnjae.github.io/content/posts",
      },
    },
    conceal_links = true,
    key_mappings = { prefix = "s" },
  })
end

vim.keymap.set("n", "<F4>", "<cmd>Lazy<CR>", {})
