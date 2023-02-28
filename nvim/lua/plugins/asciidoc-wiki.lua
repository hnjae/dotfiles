return {
  dir = "~/Sync/Projects/asciidoc-wiki.nvim",
  name = "asciidoc-wiki",
  dev = true,
  opts = {
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
  },
}
