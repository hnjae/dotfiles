-- $XDG_CONFIG_HOME/nvim/init.lua

_MAPPING_PREFIX = {
  ["tab"] = "<Leader>nt",
  ["edit"] = "<Leader>ne",
  ["window"] = "<Leader>nw",
  ["sidebar"] = "<Leader>s",
}

require('user.builtin').setup()

require('global-var')
require('setup-lazy')

require('user.autocmd').setup()
require('user.mapping').setup()

local status_wk, wiki = pcall(require, "asciidoc-wiki")
if status_wk then
  wiki.setup {
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
  }
end
