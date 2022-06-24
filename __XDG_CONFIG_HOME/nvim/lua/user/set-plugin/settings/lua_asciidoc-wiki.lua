local status_ok, wiki = pcall(require, "asciidoc-wiki")

if status_ok then
  wiki.setup{
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
