if _IS_PLUGIN('vim-asciidoctor') then
  -- TODO: read from environment variable <2022-06-16, Hyunjae Kim>
  -- NOTE: handlr can not handle asciidoc file. It recognize it as text file.
  vim.g.asciidoctor_opener = "!firefox"

  vim.g.asciidoctor_folding = 1
  vim.g.asciidoctor_fenced_languages = {
    'html', 'python', 'java', 'sh', 'ruby', "dockerfile"
  }
  vim.g.asciidoctor_syntax_conceal = 1

end
