vim.g.markdown_fenced_languages = {
  'html', 'python', 'bash=sh', 'java', 'sh'
}

if _IS_PLUGIN('vim-markdown') then

  -- conceal, syntax
  -- vim.g.vim_markdown_conceal = 0
  -- vim.g.tex_conceal = ""
  vim.g.vim_markdown_conceal_code_blocks = 0
  vim.g.vim_markdown_strikethrough = 1
  -- vim.g.vim_markdown_math = 1
  vim.g.vim_markdown_frontmatter = 1

  vim.g.vim_markdown_no_extensions_in_markdown = 1
  vim.g.vim_markdown_autowrite = 1


  -- folding
  vim.g.vim_markdown_folding_style_pythonic = 1
  vim.g.vim_markdown_override_foldtext = 1
  vim.g.vim_markdown_folding_level = 6

  -- vim.g.markdown_new_list_item_indent = 4
  --
  vim.g.vim_markdown_conceal_code_blocks = 0

  vim.g.vim_markdown_follow_anchor = 1


  vim.g.vim_markdown_no_default_key_mappings = 0
  vim.g.vim_markdown_no_extensions_in_markdown = 1

end
