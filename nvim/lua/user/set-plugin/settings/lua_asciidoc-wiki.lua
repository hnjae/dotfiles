local M = {}

local status_wk, wiki = pcall(require, "asciidoc-wiki")

M.setup = function ()
  if not status_wk then
    return
  end

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

return M
